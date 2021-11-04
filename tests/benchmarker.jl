filename = "displacements.jl"
println(string("Benchmarking ", "../src/", filename))
using BenchmarkTools
include(string("../src/", filename))
using .Dispersive

benches = Dict()
println("Benchmarking k-space transform")
k_bench = @benchmark Tk()
benches["k-space"] = minimum(k_bench)

println("Benchmarking space transform")
x_bench = @benchmark Tx()
benches["x-space"] = minimum(x_bench)

display(benches)