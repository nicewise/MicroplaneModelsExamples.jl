import Pkg
Pkg.activate(joinpath(@__DIR__, "../.."))

using MicroplaneModels
using MicroplaneModelsExamples
using MaterialTestUtils
using Plots

# ============================================================================
# MC + Damage Model: Uniaxial Compression Test
# 单位系统: MPa-mm
# ============================================================================
# Model combines:
# - Mohr-Coulomb plasticity with hardening
# - Scalar damage based on equivalent strain
# ============================================================================

cfg = MCDamageConfig(
    # Elastic
    E=40000.0, ν=0.2,          # [MPa] E, [-] ν
    # MC plasticity
    c_ini=2.0, c_peak=8.0, c_res=0.5,  # [MPa] 内聚力
    α_ini=0.2, α_peak=0.5, α_res=0.3,  # [-] 摩擦系数
    γc=0.015, k=0.3,
    # Damage (strain-based, like ElasticDamage)
    γc_damage=0.008, cT=30.0, κ₀=0.0002,
    np=21,
    damage_type=:exp_zero
)
mat = create_material(cfg)

# Note: Newton convergence may fail around step 11 (same as MC model)
ε_hist, σ_hist, state_hist = uniaxial_compression(mat; nsteps=200, εmax=-0.02)

# Stress-strain curve
p1 = plot_uniaxial_test(ε_hist, σ_hist; title="MC + Damage: Uniaxial Compression")
savefig(p1, joinpath(@__DIR__, "uniaxial.png"))
println("Saved to examples/mc_damage/uniaxial.png")

# γₚ evolution using plot_state_variable
p2 = plot_state_variable(ε_hist, state_hist, extract_vector_field(:γₚ; agg=:maximum);
    ylabel="max(γₚ)", title="MC + Damage: γₚ Evolution")
savefig(p2, joinpath(@__DIR__, "gamma_p.png"))
println("Saved to examples/mc_damage/gamma_p.png")
