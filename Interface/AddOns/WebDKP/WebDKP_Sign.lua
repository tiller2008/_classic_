WebDKP_sign={}local a,b,c,d,e=string.char,string.byte,string.format,string.rep,string.sub;local f,g,h,i,j,k;local function l(m)local n=0;local o=1;for p=1,#m do n=n+m[p]*o;o=o*2 end;return n end;local function q(r,s)local t,u=r,s;if#t<#u then t,u=u,t end;for p=#u+1,#t do u[p]=0 end end;local v;h=function(w)local m=v(w)local x=math.max(#m,32)for p=1,x do if m[p]==1 then m[p]=0 else m[p]=1 end end;return l(m)end;v=function(w)if w<0 then return v(h(math.abs(w))+1)end;local m={}local y=1;local z;while w>0 do z=w%2;m[y]=z;w=(w-z)/2;y=y+1 end;return m end;f=function(A,w)local B=v(A)local C=v(w)q(B,C)local m={}for p=1,#B do if B[p]==0 and C[p]==0 then m[p]=0 else m[p]=1 end end;return l(m)end;g=function(A,w)local B=v(A)local C=v(w)q(B,C)local m={}for p=1,#B do if B[p]==0 or C[p]==0 then m[p]=0 else m[p]=1 end end;return l(m)end;i=function(A,w)local B=v(A)local C=v(w)q(B,C)local m={}for p=1,#B do if B[p]~=C[p]then m[p]=1 else m[p]=0 end end;return l(m)end;j=function(w,D)local E=0;if w<0 then w=h(math.abs(w))+1;E=0x80000000 end;local F=math.floor;for p=1,D do w=w/2;w=f(F(w),E)end;return F(w)end;k=function(w,D)if w<0 then w=h(math.abs(w))+1 end;for p=1,D do w=w*2 end;return g(w,0xFFFFFFFF)end;local function G(p)local H=function(I)return a(g(j(p,I),255))end;return H(0)..H(8)..H(16)..H(24)end;local function J(I)local K=0;for p=1,#I do K=K*256+b(I,p)end;return K end;local function L(I)local K=0;for p=#I,1,-1 do K=K*256+b(I,p)end;return K end;local function M(I,...)local N,O=1,{}local P={...}for p=1,#P do table.insert(O,L(e(I,N,N+P[p]-1)))N=N+P[p]end;return O end;local Q=function(R)return J(G(R))end;local S={0xd76aa478,0xe8c7b756,0x242070db,0xc1bdceee,0xf57c0faf,0x4787c62a,0xa8304613,0xfd469501,0x698098d8,0x8b44f7af,0xffff5bb1,0x895cd7be,0x6b901122,0xfd987193,0xa679438e,0x49b40821,0xf61e2562,0xc040b340,0x265e5a51,0xe9b6c7aa,0xd62f105d,0x02441453,0xd8a1e681,0xe7d3fbc8,0x21e1cde6,0xc33707d6,0xf4d50d87,0x455a14ed,0xa9e3e905,0xfcefa3f8,0x676f02d9,0x8d2a4c8a,0xfffa3942,0x8771f681,0x6d9d6122,0xfde5380c,0xa4beea44,0x4bdecfa9,0xf6bb4b60,0xbebfbc70,0x289b7ec6,0xeaa127fa,0xd4ef3085,0x04881d05,0xd9d4d039,0xe6db99e5,0x1fa27cf8,0xc4ac5665,0xf4292244,0x432aff97,0xab9423a7,0xfc93a039,0x655b59c3,0x8f0ccc92,0xffeff47d,0x85845dd1,0x6fa87e4f,0xfe2ce6e0,0xa3014314,0x4e0811a1,0xf7537e82,0xbd3af235,0x2ad7d2bb,0xeb86d391,0x67452301,0xefcdab89,0x98badcfe,0x10325476}local H=function(T,U,V)return f(g(T,U),g(-T-1,V))end;local W=function(T,U,V)return f(g(T,V),g(U,-V-1))end;local X=function(T,U,V)return i(T,i(U,V))end;local p=function(T,U,V)return i(U,f(T,-V-1))end;local V=function(Y,Z,_,a0,a1,T,I,a2)Z=g(Z+Y(_,a0,a1)+T+a2,0xFFFFFFFF)return f(k(g(Z,j(0xFFFFFFFF,I)),I),j(Z,32-I))+_ end;local function a3(a4,a5,a6,a7,a8)local Z,_,a0,a1=a4,a5,a6,a7;local a9=S;Z=V(H,Z,_,a0,a1,a8[0],7,a9[1])a1=V(H,a1,Z,_,a0,a8[1],12,a9[2])a0=V(H,a0,a1,Z,_,a8[2],17,a9[3])_=V(H,_,a0,a1,Z,a8[3],22,a9[4])Z=V(H,Z,_,a0,a1,a8[4],7,a9[5])a1=V(H,a1,Z,_,a0,a8[5],12,a9[6])a0=V(H,a0,a1,Z,_,a8[6],17,a9[7])_=V(H,_,a0,a1,Z,a8[7],22,a9[8])Z=V(H,Z,_,a0,a1,a8[8],7,a9[9])a1=V(H,a1,Z,_,a0,a8[9],12,a9[10])a0=V(H,a0,a1,Z,_,a8[10],17,a9[11])_=V(H,_,a0,a1,Z,a8[11],22,a9[12])Z=V(H,Z,_,a0,a1,a8[12],7,a9[13])a1=V(H,a1,Z,_,a0,a8[13],12,a9[14])a0=V(H,a0,a1,Z,_,a8[14],17,a9[15])_=V(H,_,a0,a1,Z,a8[15],22,a9[16])Z=V(W,Z,_,a0,a1,a8[1],5,a9[17])a1=V(W,a1,Z,_,a0,a8[6],9,a9[18])a0=V(W,a0,a1,Z,_,a8[11],14,a9[19])_=V(W,_,a0,a1,Z,a8[0],20,a9[20])Z=V(W,Z,_,a0,a1,a8[5],5,a9[21])a1=V(W,a1,Z,_,a0,a8[10],9,a9[22])a0=V(W,a0,a1,Z,_,a8[15],14,a9[23])_=V(W,_,a0,a1,Z,a8[4],20,a9[24])Z=V(W,Z,_,a0,a1,a8[9],5,a9[25])a1=V(W,a1,Z,_,a0,a8[14],9,a9[26])a0=V(W,a0,a1,Z,_,a8[3],14,a9[27])_=V(W,_,a0,a1,Z,a8[8],20,a9[28])Z=V(W,Z,_,a0,a1,a8[13],5,a9[29])a1=V(W,a1,Z,_,a0,a8[2],9,a9[30])a0=V(W,a0,a1,Z,_,a8[7],14,a9[31])_=V(W,_,a0,a1,Z,a8[12],20,a9[32])Z=V(X,Z,_,a0,a1,a8[5],4,a9[33])a1=V(X,a1,Z,_,a0,a8[8],11,a9[34])a0=V(X,a0,a1,Z,_,a8[11],16,a9[35])_=V(X,_,a0,a1,Z,a8[14],23,a9[36])Z=V(X,Z,_,a0,a1,a8[1],4,a9[37])a1=V(X,a1,Z,_,a0,a8[4],11,a9[38])a0=V(X,a0,a1,Z,_,a8[7],16,a9[39])_=V(X,_,a0,a1,Z,a8[10],23,a9[40])Z=V(X,Z,_,a0,a1,a8[13],4,a9[41])a1=V(X,a1,Z,_,a0,a8[0],11,a9[42])a0=V(X,a0,a1,Z,_,a8[3],16,a9[43])_=V(X,_,a0,a1,Z,a8[6],23,a9[44])Z=V(X,Z,_,a0,a1,a8[9],4,a9[45])a1=V(X,a1,Z,_,a0,a8[12],11,a9[46])a0=V(X,a0,a1,Z,_,a8[15],16,a9[47])_=V(X,_,a0,a1,Z,a8[2],23,a9[48])Z=V(p,Z,_,a0,a1,a8[0],6,a9[49])a1=V(p,a1,Z,_,a0,a8[7],10,a9[50])a0=V(p,a0,a1,Z,_,a8[14],15,a9[51])_=V(p,_,a0,a1,Z,a8[5],21,a9[52])Z=V(p,Z,_,a0,a1,a8[12],6,a9[53])a1=V(p,a1,Z,_,a0,a8[3],10,a9[54])a0=V(p,a0,a1,Z,_,a8[10],15,a9[55])_=V(p,_,a0,a1,Z,a8[1],21,a9[56])Z=V(p,Z,_,a0,a1,a8[8],6,a9[57])a1=V(p,a1,Z,_,a0,a8[15],10,a9[58])a0=V(p,a0,a1,Z,_,a8[6],15,a9[59])_=V(p,_,a0,a1,Z,a8[13],21,a9[60])Z=V(p,Z,_,a0,a1,a8[4],6,a9[61])a1=V(p,a1,Z,_,a0,a8[11],10,a9[62])a0=V(p,a0,a1,Z,_,a8[2],15,a9[63])_=V(p,_,a0,a1,Z,a8[9],21,a9[64])return g(a4+Z,0xFFFFFFFF),g(a5+_,0xFFFFFFFF),g(a6+a0,0xFFFFFFFF),g(a7+a1,0xFFFFFFFF)end;local function aa(self,I)self.pos=self.pos+#I;I=self.buf..I;for ab=1,#I-63,64 do local a8=M(e(I,ab,ab+63),4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4)assert(#a8==16)a8[0]=table.remove(a8,1)self.a,self.b,self.c,self.d=a3(self.a,self.b,self.c,self.d,a8)end;self.buf=e(I,math.floor(#I/64)*64+1,#I)return self end;local function ac(self)local ad=self.pos;local ae=56-ad%64;if ad%64>56 then ae=ae+64 end;if ae==0 then ae=64 end;local I=a(128)..d(a(0),ae-1)..G(g(8*ad,0xFFFFFFFF))..G(math.floor(ad/0x20000000))aa(self,I)assert(self.pos%64==0)return G(self.a)..G(self.b)..G(self.c)..G(self.d)end;function WebDKP_sign.new()return{a=S[65],b=S[66],c=S[67],d=S[68],pos=0,buf='',update=aa,finish=ac}end;function WebDKP_sign.tohex(I)local af=pcall(string.format,"%08x",2^32)if af then return c("%08x%08x%08x%08x",J(e(I,1,4)),J(e(I,5,8)),J(e(I,9,12)),J(e(I,13,16)))else return c("%06x%06x%06x%06x%06x%02x",J(e(I,1,3)),J(e(I,4,6)),J(e(I,7,9)),J(e(I,10,12)),J(e(I,13,15)),J(e(I,16,16)))end end;function WebDKP_sign.sum(I)return WebDKP_sign.new():update(I):finish()end;function WebDKP_sign.sumhexa(I)return WebDKP_sign.tohex(WebDKP_sign.sum(I))end
