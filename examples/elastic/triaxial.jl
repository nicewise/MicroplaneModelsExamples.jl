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

cfg = ElasticConfig(; E=E, ν=ν, np=21)
mat = create_material(cfg)

σr = -10.0  # [MPa] 围压

ε_hist, σ_hist, state_hist, nsteps_confining = triaxial_compression(
    mat; nsteps=50, εmax=-0.01, σr=σr, nsteps_confining=10
)

p1 = plot_triaxial_test(ε_hist, σ_hist; nsteps_confining=nsteps_confining, title="Elastic: Triaxial Test (σᵣ = $(-σr) MPa)")
savefig(p1, joinpath(@__DIR__, "triaxial.png"))
println("Saved to examples/elastic/triaxial.png")

println("\n=== Verification: Isotropic Linear Elastic Analytical Solution ===")
println("Young's modulus E = $E")
println("Poisson's ratio nu = $ν")

G = E / (2 * (1 + ν))
K = E / (3 * (1 - 2ν))

println("Shear modulus G = $G")
println("Bulk modulus K = $K")

println("\nConfining stage verification:")
for i in 1:min(nsteps_confining, 3)
    σ = σ_hist[i+1]
    σ11, σ22, σ33 = σ[1,1], σ[2,2], σ[3,3]
    ε11, ε22, ε33 = ε_hist[i+1][1,1], ε_hist[i+1][2,2], ε_hist[i+1][3,3]
    
    εv = ε11 + ε22 + ε33
    σm = (σ11 + σ22 + σ33) / 3
    
    σm_analytical = K * εv
    
    println("  Step $i: sigma_m=$(round(σm, digits=2)), sigma_m_ana=$(round(σm_analytical, digits=2)), eps_v=$(round(εv, digits=6))")
end

println("\nShear stage verification (deviatoric stress q):")
println("Formula: q = 2G * (eps_zz - eps_rr)")
for i in (nsteps_confining+1):5:length(σ_hist)
    σ = σ_hist[i]
    ε = ε_hist[i]
    
    σrr = (σ[1,1] + σ[2,2]) / 2
    σzz = σ[3,3]
    εrr = (ε[1,1] + ε[2,2]) / 2
    εzz = ε[3,3]
    
    q_num = σzz - σrr
    
    εq = εzz - εrr
    q_analytical = 2 * G * εq
    
    err = abs(q_num - q_analytical)
    rel_err = err / abs(q_analytical) * 100
    
    println("  Step $i: q_num=$(round(q_num, digits=2)), q_ana=$(round(q_analytical, digits=2)), rel_err=$(round(rel_err, digits=4))%")
end
