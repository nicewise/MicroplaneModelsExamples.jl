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

# 弹性损伤模型配置 (推荐使用默认的 exp_zero 模式)
#
# 损伤演化类型 (通过 damage_type 设置):
#   :exp_zero    - 纯指数衰减，后期应力趋近于0 (默认，推荐)
#   :power_zero - 纯乘幂衰减，后期应力趋近于0
#   :exp         - 旧指数形式，φ_res>0 时后期会回升 (不推荐)
#   :power       - 旧乘幂形式，φ_res>0 时后期会回升 (不推荐)
#
# 默认使用 :exp_zero，无需设置 phi_res

cfg = ElasticDamageConfig(
    E=40000.0, ν=0.2,    # [MPa] 弹性模量, [-] 泊松比
    γc=0.008,             # 损伤演化速率
    cT=30.0, κ₀=0.0002,  # 切向权重, 损伤阈值
    np=21
    # damage_type 默认 :exp_zero
)
mat = create_material(cfg)

# 单轴压缩
ε_hist_c, σ_hist_c, state_hist_c = uniaxial_compression(mat; nsteps=150, εmax=-0.015)

# 单轴拉伸
ε_hist_t, σ_hist_t, state_hist_t = uniaxial_tension(mat; nsteps=150, εmax=0.003)

# 绘制压缩结果
p1 = plot_uniaxial_test(ε_hist_c, σ_hist_c; title="Elastic Damage: Uniaxial Compression (E = 40 GPa)")
savefig(p1, joinpath(@__DIR__, "uniaxial_compression.png"))

# 绘制拉伸结果
p2 = plot_uniaxial_test(ε_hist_t, σ_hist_t; title="Elastic Damage: Uniaxial Tension (E = 40 GPa)")
savefig(p2, joinpath(@__DIR__, "uniaxial_tension.png"))

println("Saved to examples/elastic_damage/uniaxial_compression.png")
println("Saved to examples/elastic_damage/uniaxial_tension.png")
