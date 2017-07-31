include("../src/physics/twodturb.jl")

# using PyPlot
using TwoDTurb

nu  = 1e-6    # Vorticity hyperviscosity
nun = 4       # Vorticity hyperviscosity order
Lx  = 2.0*pi
nx  = 128
dt  = 1e-4;


# Initial condition with two ellipsoid vortices for comparison.
ampl = 1.131562576275490e-04
qh = ampl*rfft( 200.0*exp.(-((g.X-1).^2-0.4*g.X.*g.Y)./.3^2-(g.Y-1).^2./.5^2) 
  - 100.0* exp.(-((g.X+1).^2-0.4*g.X.*g.Y)./.3^2-(g.Y+1).^2./.5^2) )

qh[1, 1] = 0



println("Initialize grid, vars, params, time stepper:")
@time g = Grid(nx, Lx);
@time p = Params(f0, nuq, nuqn, g);
@time v = Vars(p, g);
@time qts = ForwardEulerTimeStepper(dt, p.LC);
# @time qts = ETDRK4TimeStepper(dt, p.LCq);

Solver.updatevars!(v,p,g);

# println(v.q[10,14])

# Lz = qts.LC.*v.qh;
# println(Lz[4,5])


# figure(1);
# pcolor(g.X,g.Y,v.q)
# colorbar();
# axis(:equal);xlim(-pi,pi);ylim(-pi,pi);
for n in 1:3
  println("step ",n)
  nsteps = 50;
  @time Solver.stepforward!(nsteps, qts, v, p, g)
  Solver.updatevars!(v,p,g);
  # figure(1);clf()
  # pcolor(g.X,g.Y,v.q)
  # axis(:equal);xlim(-pi,pi);ylim(-pi,pi);
  # colorbar()
end