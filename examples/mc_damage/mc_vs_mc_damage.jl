import Pkg
Pkg.activate(joinpath(@__DIR__, "../.."))

using MicroplaneModels
using MicroplaneModelsExamples
using MaterialTestUtils
using Plots
gr()

cfg_mc = MCConfig(
    E=40000.0, ν=0.2,
    c_ini=2.0, c_peak=8.0, c_res=0.5,
    α_ini=0.2, α_peak=0.5, α_res=0.3,
    γc=0.02, k=0.3, np=21
)
mat_mc = create_material(cfg_mc)

ε_hist_mc, σ_hist_mc, state_hist_mc = uniaxial_compression(mat_mc; nsteps=30, εmax=-0.002)

cfg_mc_damage = MCDamageConfig(
    E=40000.0, ν=0.2,
    c_ini=2.0, c_peak=8.0, c_res=0.5,
    α_ini=0.2, α_peak=0.5, α_res=0.3,
    γc=0.02, k=0.3,
    γc_damage=0.005, cT=30.0, κ₀=0.0002,
    np=21,
    damage_type=:exp_zero
)
mat_mc_damage = create_material(cfg_mc_damage)

ε_hist_mc_dmg, σ_hist_mc_dmg, state_hist_mc_dmg = uniaxial_compression(mat_mc_damage; nsteps=30, εmax=-0.002)

# Extract σ33 (loading direction stress)
σ33_mc = Float64[-s[3,3] for s in σ_hist_mc]
σ33_dmg = Float64[-s[3,3] for s in σ_hist_mc_dmg]
ε_plot = Float64[-e[3,3] for e in ε_hist_mc]

p1 = plot(ε_plot, σ33_mc, label="MC (plasticity)", linewidth=2, color=:blue)
plot!(p1, ε_plot, σ33_dmg, label="MC-Damage (plasticity + damage)", linewidth=2, color=:red, linestyle=:dash)
xlabel!("Strain")
ylabel!("Stress (MPa)")
title!("MC vs MC-Damage: Uniaxial Compression")
savefig(p1, joinpath(@__DIR__, "mc_comparison.png"))

println("MC max: ", maximum(σ33_mc), " final: ", σ33_mc[end])
println("MC-Damage max: ", maximum(σ33_dmg), " final: ", σ33_dmg[end])
