import Pkg
Pkg.activate(joinpath(@__DIR__, "../.."))

using MicroplaneModels
using MicroplaneModelsExamples
using MaterialTestUtils
using Plots
using LinearAlgebra

# ============================================================================
# 单位系统: MPa-mm
# ============================================================================
# - 应力: MPa
# - 弹性模量: MPa  
# - 应变: 无量纲 (mm/mm)
# ============================================================================

E = 40000.0  # [MPa] Young's modulus (40 GPa)
ν = 0.2      # [-] Poisson's ratio

cfg = ElasticConfig(; E=E, ν=ν, np=110)
mat = create_material(cfg)

ε_hist, σ_hist, state_hist = uniaxial_compression(mat; nsteps=50, εmax=-0.01)

p1 = plot_uniaxial_test(ε_hist, σ_hist; title="Elastic: Uniaxial Test")
savefig(p1, joinpath(@__DIR__, "uniaxial.png"))

println("\n=== Verification: vs Analytical Solution ===")

εzz = [ε[3, 3] for ε in ε_hist]
σzz = [σ[3, 3] for σ in σ_hist]

σ_analytical = E .* εzz

max_err = maximum(abs.(σzz .- σ_analytical))
rel_err = max_err / maximum(abs.(σ_analytical))

println("Axial strain range: [$(minimum(εzz)), $(maximum(εzz))]")
println("Axial stress range: [$(minimum(σzz)), $(maximum(σzz))]")
println("Analytical stress range: [$(minimum(σ_analytical)), $(maximum(σ_analytical))]")
println("Max absolute error: $max_err")
println("Max relative error: $(rel_err * 100)%")

for i in [1, 10, 25, 50]
    ε = ε_hist[i][3, 3]
    σ_num = σ_hist[i][3, 3]
    σ_ana = E * ε
    err = abs(σ_num - σ_ana)
    println("Step $i: eps=$ε, sigma_num=$σ_num, sigma_ana=$σ_ana, err=$err")
end

p2 = plot(εzz, [σzz σ_analytical], 
    label=["Microplane" "Analytical (sigma=E*eps)"],
    xlabel="eps_zz", ylabel="sigma_zz",
    title="Comparison with Analytical Solution",
    linewidth=2,
    legend=:topleft
)
savefig(p2, joinpath(@__DIR__, "uniaxial_verification.png"))

println("Saved to examples/elastic/uniaxial.png")
println("Saved to examples/elastic/uniaxial_verification.png")
