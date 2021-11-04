module Gaussian

export xs, ts, u

xs = range(0, 9, length=100)
frames = 100
ts = range(0, 1, step=1/frames)
L = 1
c = 5
uf(x, t) = exp.( -(x .- c*t).^2 ./ (2*L^2) )
u = [uf(x, t) for x in xs, t in ts]

end

module Dispersive

using QuadGK, NumericalIntegration

export xs, ts, u, Tk, Tx, u0

L = 1
N = Integer(5e2) + 1
B = 10
maxevals = 10^4
xs = range(-B*L, B*L, length=N)
ks = range(-B/L, B/L, length=N)

# Dispersion relation
nu = 1e15
a = 1e-7
#a = 0 # does not propagate?
omega(k) = nu*(1+(a*k)^2/2)

# Source distribution
# u0(x) = exp.( -(x).^2 ./ (2*L^2) ) # does not propagate?
k0 = B/(2*L); u0(x) = exp.( -(x).^2 ./ (2*L^2) ) * cos(k0*x)

println("Transforming to k space")
# Transform
function Tk()
    U = complex(zeros(N))
    for (l,k) in enumerate(ks)
        u0I(x) = u0(x) * exp(-1im*k*x)
        U[l] = (2*pi)^(-1/2) * quadgk(u0I, xs[1], xs[end], maxevals=maxevals)[1]
    end
    return U
end

U = Tk()

println("Appending time steps")
# Inverse transform
frames = Integer(1e3)
ts = range(0, 0.3, length=frames)
function Tx()
    u = zeros(N, frames)
    for (j,t) in enumerate(ts)
    for (i,x) in enumerate(xs)
        UI = U .* exp.(1im*(ks*x - omega.(ks)*t))
        uc = (2*pi)^(-1/2) * integrate(ks, UI)
        u[i,j] = real(uc)
    end
    end
    return u
end

u = Tx()

end