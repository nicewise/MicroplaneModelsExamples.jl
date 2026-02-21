import Pkg
Pkg.activate(joinpath(@__DIR__, "../.."))

using MicroplaneModels
using MicroplaneModelsExamples
using MaterialTestUtils
using Plots

# ============================================================================
# 单位系统: MPa-mm
# ============================================================================
# - 应力: MPa
# - 弹性模量: MPa
# - 内聚力 c: MPa
# - 应变: 无量纲 (mm/mm)
# ============================================================================

cfg = MCConfig(
    E=40000.0, ν=0.2,          # [MPa] E, [-] ν
    c_ini=2.0, c_peak=8.0, c_res=0.5,  # [MPa] 内聚力
    α_ini=0.2, α_peak=0.5, α_res=0.3,  # [-] 摩擦系数
    γc=0.015, k=0.3, np=110
)
mat = create_material(cfg)

ε_hist, σ_hist, state_hist = uniaxial_compression(mat; nsteps=200, εmax=-0.02)

p1 = plot_uniaxial_test(ε_hist, σ_hist; title="MC: Uniaxial Compression")
savefig(p1, joinpath(@__DIR__, "uniaxial.png"))
println("Saved to examples/mc/uniaxial.png")
