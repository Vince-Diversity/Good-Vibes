module Color

    export fig, recoord, change_function, hue_iterator, framerate

    using GLMakie
    using Makie.Colors

    fig, ax, lineplot = lines(0..10, sin; linewidth=10)

    # animation settings
    nframes = 300
    framerate = 30
    hue_iterator = range(0, 360, length=nframes)

    function change_function(hue)
        lineplot.color = HSV(hue, 1, 0.75)
    end

    function recoord()
    record(change_function, fig, "color_animation.mp4", hue_iterator; framerate = framerate)
    end

end

module Observable

    using GLMakie

    time = Node(0.0)

    xs = range(0, 7, length=40)

    ys_1 = @lift(sin.(xs .- $time))
    ys_2 = @lift(cos.(xs .- $time) .+ 3)

    fig = lines(xs, ys_1, color = :blue, linewidth = 4,
        axis = (title = @lift("t = $(round($time, digits = 1))"),))
    scatter!(xs, ys_2, color = :red, markersize = 15)

    framerate = 30
    timestamps = range(0, 2, step=1/framerate)

    record(fig, "time_animation.mp4", timestamps; framerate = framerate) do t
        time[] = t
    end

end

module Append

    using GLMakie

    points = Node(Point2f0[(0, 0)])

    fig, ax = scatter(points)
    limits!(ax, 0, 30, 0, 30)

    frames = 1:30

    record(fig, "append_animation.mp4", frames; framerate = 30) do frame
        new_point = Point2f0(frame, frame)
        points[] = push!(points[], new_point)
    end

end

module Live

    using GLMakie

    points = Node(Point2f0[randn(2)])

    fig, ax = scatter(points)
    limits!(ax, -4, 4, -4, 4)

    fps = 60
    nframes = 120

    function anim()
        for i = 1:nframes
            new_point = Point2f0(randn(2))
            points[] = push!(points[], new_point)
            sleep(1/fps) # refreshes the display!
        end
    end

end

module NodeExample

    export x

    using GLMakie, Makie

    x = Node(0.0)
    x[] = 3.3

    on(x) do x
        println("New value: $x")
    end

end

module LiftExample

export x, y, z

using GLMakie, Makie

x = Node(0.0)

f(x) = x^2
y = lift(f, x)
z = lift(y) do y
    -y
end

x[] = 10.0

end