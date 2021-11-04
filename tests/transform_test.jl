include("../src/displacements.jl")
using .Dispersive
using Plots
plotly()

#plot(xs, u0)
plot(xs, real.(u[:,1]))