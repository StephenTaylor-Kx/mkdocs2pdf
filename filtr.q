/
  Title: Preprocessor for whitepaper MDs from code.kx.com 
  Author: stephen@kx.com

  -  remove Hero lines
  -  wrap admonitions within blockquotes

  Usage: q filtr.q output input [ input [input]…]
  Exit codes: 0 ok
              1 too few arguments
              2 invalid file/s
              3 inputs not all siblings
              4 output is also an input
              5 failed to write output
\

res:{[args]		
	/ parse command-line arguments											
	usage: "Usage: q ",(string .z.f)," output input [ input [input]...]";
	if[2>count args; :(1;usage)];
	output:first args;
	inputs:1_ args;
	/ validate arguments
	ih:hsym `$inputs;                                                  		/ input file handles
	vf:{x~key x} each ih;                                              		/ valid files
	if[not all vf; :(2;"Invalid file/s: ","," sv inputs where not vf)];
	dps:first each ` vs' ih;                                           		/ directory paths
	if[not {all x~\:first x} dps; :(3;"Inputs not all siblings")];
	tgt:hsym `$(string first dps),"/",output,".md";                    		/ output target
	if[tgt in ih; :(4;"May not overwrite: ",string tgt)];
	/ assemble whole article
	raw:raze read0 each ih;
	/ remove hero lines
	cooked:raw where not "hero:"~/:5#'raw;
	/ find and wrap admonitions
	as:where "!!!"~/:3#'cooked;												/ admonition starts
	/ admonitions continue while lines are empty or indented with four spaces
	ia:raze as+til each{sum(&\)"    "~/:4#'1_ x}each as _ cooked;		/ indexes of admonition lines
	cooked[ia]:">",/:cooked[ia];											/ mark as blockquotes

	r:tgt 0: cooked;
	if[not r~tgt; :(5;"Failed to write to ",string tgt)];
	(0;"Wrote ",string tgt)
	}.z.x

$[res 0; -2; -1] res 1;                                                     / result message
exit res 0																	/ exit code
4#