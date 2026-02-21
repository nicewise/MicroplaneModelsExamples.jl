import Pkg
Pkg.activate(joinpath(@__DIR__, "../.."))

using MicroplaneModels
using MicroplaneModelsExamples
using MaterialTestUtils
using Plots

# ============================================================================
# MC + Damage Model: Triaxial Compression Test
# 单位系统: MPa-mm
# ============================================================================
# Model combines:
# - Mohr-Coulomb plasticity with hardening
# - Scalar damage based on equivalent strain
# ============================================================================

# For triaxial, use more conservative damage parameters for better convergence
# - Larger γc_damage = slower damage evolution = better convergence
# - Larger κ₀ = later damage initiation = better convergence
cfg = MCDamageConfig(
    # Elastic
    E=40000.0, ν=0.2,          # [MPa] E, [-] ν
    # MC plasticity
    c_ini=2.0, c_peak=8.0, c_res=0.5,  # [MPa] 内聚力
    α_ini=0.2, α_peak=0.5, α_res=0.3,  # [-] 摩擦系数
    γc=0.015, k=0.3,
    # Damage - very conservative for triaxial
    γc_damage=0.05, cT=100.0, κ₀=0.02,
    np=110,
    damage_type=:exp_zero
)
mat = create_material(cfg)

# Use smaller εmax and more steps for better convergence
# Note: Convergence may fail in late softening stages due to severe stiffness degradation
ε_hist, σ_hist, state_hist, nsteps_confining = triaxial_compression(
    mat; nsteps=200, εmax=-0.02, σr=-30.0, nsteps_confining=30
)

# Use existing plotting function
p1 = plot_triaxial_test(ε_hist, σ_hist; nsteps_confining=nsteps_confining, title="MC + Damage: Triaxial (σᵣ = 30 MPa)")
savefig(p1, joinpath(@__DIR__, "triaxial.png"))
println("Saved to examples/mc_damage/triaxial.png")
