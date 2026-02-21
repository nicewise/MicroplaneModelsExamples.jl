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
# - 应变: 无量纲 (mm/mm)
# - 位移: mm
# ============================================================================

# 弹性损伤模型配置 (三轴试验推荐参数)
#
# 损伤演化类型: 默认 :exp_zero (推荐)

cfg = ElasticDamageConfig(
    E=40000.0, ν=0.2,       # [MPa] 弹性模量, [-] 泊松比
    γc=0.02,                # 损伤演化速率 (三轴更保守)
    cT=100.0, κ₀=0.01,     # 切向权重, 损伤阈值
    np=110
    # 默认使用 damage_type=:exp_zero
)
mat = create_material(cfg)

# 三轴压缩试验
# σr = 5 MPa (围压)
ε_hist, σ_hist, state_hist, nsteps_confining = triaxial_compression(
    mat; nsteps=30, εmax=-0.03, σr=-5.0, nsteps_confining=15
)

p1 = plot_triaxial_test(ε_hist, σ_hist; nsteps_confining=nsteps_confining, 
                         title="Elastic Damage: Triaxial (σᵣ = 5 MPa, E = 40 GPa)")
savefig(p1, joinpath(@__DIR__, "triaxial.png"))
println("Saved to examples/elastic_damage/triaxial.png")

# 打印关键结果
println()
println("=== 三轴测试结果 ===")
final_σ = σ_hist[end]
println("最终轴向应力: σzz = $(round(final_σ[3,3], sigdigits=4)) MPa")
println("围压: σxx = $(round(final_σ[1,1], sigdigits=4)) MPa")
