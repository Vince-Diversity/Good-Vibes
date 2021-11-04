module Pulse

println("Adding displacement function")
include("displacements.jl")

using GLMakie, .Dispersive
export animate, fps, fig

println("Animating")

timestep = Node(1)

ys_1 = @lift(u[:, $timestep])
ys_max = max(u[:,1]...)

fig = lines(xs, ys_1, color = :blue, linewidth = 4,
    axis = (title = @lift("t = $(round(ts[$timestep], digits = 2))"),
            xlabel = "x", ylabel = "Amplitude")
            )
ylims!(-ys_max, ys_max)

fr = 5
frames = size(u)[2]
timesteps = 1:1:frames
record(fig, "time_animation.mp4", timesteps; framerate = fr) do i
    timestep[] = i
end

fps = Node(fr)

function animate()
    timestep[] = 1
    for i = 1:frames
        timestep[] = i
        sleep(1/fps[]) # refreshes the display!
    end

end

end