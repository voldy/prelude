-module(eqc_new_fun).

-compile(export_all).

-include_lib("eqc/include/eqc.hrl").

collect_expr_locs(AST) ->
    F1 = fun (T,S) ->
		 case api_refac:is_expr(T) orelse (wrangler_syntax:type(T)==match_expr) of
		     true -> Range = api_refac:start_end_loc(T),
			     [Range| S];
		     _ -> S
		 end
	 end,
    F = fun (T, S) ->
		case wrangler_syntax:type(T) of
		    clause ->
                        Body=wrangler_syntax:clause_body(T),
                        Len = length(Body),
                        if Len>3 ->
                                Range = api_refac:start_end_loc(lists:sublist(Body, 2, length(Body)-2)),
                                [Range|S];
                           true ->
                                api_ast_traverse:fold(F1, [], T) ++ S
                        end;
		    _ -> S
		end
	end,
    Res = lists:usort(api_ast_traverse:fold(F, [], AST)),
    case Res of
	[] ->
	    [{{0,0}, {0,0}}];
	_ -> Res
    end.

%% Default function names.
madeup_fun_names() -> ["aaa", "bbb", "ccc", "DDD"].

%% Collect atoms in an AST.
collect_atoms(AST) ->
    F = fun (T, S) ->
		case wrangler_syntax:type(T) of
		    atom ->
			Name = wrangler_syntax:atom_value(T),
			[atom_to_list(Name)] ++ S;
		    _ -> S
		end
	end,
    lists:usort(api_ast_traverse:fold(F, madeup_fun_names(), AST)).

%% filename newerator
gen_filename(Dirs) ->
    AllErlFiles = wrangler_misc:expand_files(Dirs, ".erl"),
    oneof(AllErlFiles).


%% Properties for 'generalise a function'
prop_new_fun({FName, Range, NewName, _SearchPaths, TabWidth}) ->
    Res0= case (catch compile:file(FName, [{i, "c:/cygwin/home/hl/test_codebase"}])) of
	      {ok, _} -> ok;
	      _ -> fail
	  end,
    {Start, End} = Range,
    Args = [FName,Start, End, NewName, emacs, TabWidth],
    try  apply(refac_new_fun, fun_extraction, Args)  of
	 {ok, Res} -> 
	    wrangler_preview_server:commit(),
	    case compile:file(FName,[]) of 
		{ok, _} -> 
		    wrangler_undo_server:undo(),
		    io:format("\n~p\n", [{ok, Res}]),
		    true;
		Error -> 
		    case Res0 of 
			ok ->
			    io:format("\nResulted file does not Compile:~p\n", [Error]),
			    wrangler_undo_server:undo(),false;
			fail ->
			    wrangler_undo_server:undo(),true
		    end
	    end;
	 {error, Msg} -> 
	    io:format("\n~p\n", [{error,Msg}]),
	    true	
    catch 
	throw:Error -> 
	    io:format("Error:\n~p\n", [Error]),
	    true;
	  E1:E2 ->
	    io:format("E1:E2:\n~p\n", [{E1, E2}]),
	    false
    end.
	       
gen_new_fun_commands(Dirs) ->
    ?LET(FileName, (gen_filename(Dirs)),
	 gen_new_fun_commands_1(FileName, Dirs)).

%% generate 'gen a function' commands.
gen_new_fun_commands_1(FileName, Dirs) ->
    {ok, {AST, _Info}} = wrangler_ast_server:parse_annotate_file(FileName, true, Dirs, 8),
    noshrink({FileName, oneof(collect_expr_locs(AST)), oneof(collect_atoms(AST)), Dirs, 8}).

show_new_fun_commands(Dirs)->
    eqc:quickcheck(?FORALL (C, (gen_new_fun_commands(Dirs)), (eqc:collect(C, true)))).
		
	  
test_new_fun(Dirs) ->
    application:start(wrangler),
    eqc:quickcheck(numtests(500, ?FORALL(C, (gen_new_fun_commands(Dirs)), prop_new_fun(C)))),
    application:start(wrangler).
	
    
   
test_new_fun1() ->
    test_new_fun(["c:/cygwin/home/hl/test_codebase/lampera"]).

test_new_fun2() ->
    test_new_fun(["c:/cygwin/home/hl/test_codebase/eunit"]).

test_new_fun3() ->
    test_new_fun(["c:/cygwin/home/hl/test_codebase/refactorerl"]).

test_new_fun4() ->
    test_new_fun(["c:/cygwin/home/hl/test_codebase/ibrowse"]).

test_new_fun5() ->
    test_new_fun(["c:/cygwin/home/hl/test_codebase/wrangler"]).

test_new_fun6() ->
    test_new_fun(["c:/cygwin/home/hl/test_codebase/stdlib"]).

test_new_fun7() ->
    test_new_fun(["c:/cygwin/home/hl/test_codebase/yxa"]).

test_new_fun8() ->
    test_new_fun(["c:/cygwin/home/hl/test_codebase/dialyzer"]).

test_new_fun9() ->
    test_new_fun(["c:/cygwin/home/hl/test_codebase/syntax_tools"]).

run_test_new_fun() ->
    test_new_fun1(),
    test_new_fun2(),
    test_new_fun3(),
    test_new_fun4(),
    test_new_fun5(),
    test_new_fun6(),
    test_new_fun7(),
    test_new_fun8().
    
