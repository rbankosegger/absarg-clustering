% Example from 
% An Argumentation-Based Analysis of the Simonshaven Case
% Henry Prakken. Topics in Cognitive Science 12 (2020) 1068–1091

arg(A) :- att(A,_).
arg(A) :- att(_,A).

att(a,g).	
att(b,a).	att(b,aux1).	
att(aux1, aux2).	
att(aux2, c).	
att(c,b).	att(c,f).	
att(d,aux2).	att(d,e).
att(e,d).	att(e,i).
att(f,c).
att(g,a).	
att(h,g).
att(i,e).
att(j,d).	att(j,k).	att(j,l).
att(k,j).
att(l,j).
att(f',c).	att(c,f').
