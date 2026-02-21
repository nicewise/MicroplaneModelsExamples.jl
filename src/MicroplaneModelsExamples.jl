"""
    MicroplaneModelsExamples

Examples and MaterialTestUtils adapter for MicroplaneModels.

This package provides:
- Adapter to make MicroplaneMaterial work with MaterialTestUtils interface
- Example scripts for testing all microplane models
"""
module MicroplaneModelsExamples

using MicroplaneModels
using MaterialTestUtils
using Tensors

# ============================================================================
# Adapter: Extend MaterialTestUtils interface for MicroplaneMaterial
# ============================================================================

# ---- initial_material_state ----

function MaterialTestUtils.initial_material_state(material::MicroplaneMaterial{L,T}) where {L<:AbstractMicroplaneLaw,T}
    np = length(material.microplanes)
    return _initial_state_for_law(material.law, np, T)
end

_initial_state_for_law(::Elastic{T}, np::Int, ::Type{T}) where {T} = ElasticState(T=T)
_initial_state_for_law(::ElasticDamage{T}, np::Int, ::Type{T}) where {T} = ElasticDamageState(np=np, T=T)
_initial_state_for_law(::MicroplaneMC{T}, np::Int, ::Type{T}) where {T} = MicroplaneMCState(np=np, T=T)
_initial_state_for_law(::MicroplaneMCCap{T}, np::Int, ::Type{T}) where {T} = MicroplaneMCCapState(np=np, T=T)
_initial_state_for_law(::MicroplaneMCDamage{T}, np::Int, ::Type{T}) where {T} = MicroplaneMCDamageState(np=np, T=T)

# ---- compute_stress_tangent ----

function MaterialTestUtils.compute_stress_tangent(
    ε::SymmetricTensor{2,3,T}, material::MicroplaneMaterial{Elastic{T},T}, state::ElasticState{T}
) where {T<:Real}
    return MicroplaneModels.compute_stress_tangent(ε, material, state)
end

function MaterialTestUtils.compute_stress_tangent(
    ε::SymmetricTensor{2,3,T}, material::MicroplaneMaterial{ElasticDamage{T},T}, state::ElasticDamageState{T}
) where {T<:Real}
    return MicroplaneModels.compute_stress_tangent(ε, material, state)
end

function MaterialTestUtils.compute_stress_tangent(
    ε::SymmetricTensor{2,3,T}, material::MicroplaneMaterial{MicroplaneMC{T},T}, state::MicroplaneMCState{T}
) where {T<:Real}
    return MicroplaneModels.compute_stress_tangent(ε, material, state)
end

function MaterialTestUtils.compute_stress_tangent(
    ε::SymmetricTensor{2,3,T}, material::MicroplaneMaterial{MicroplaneMCCap{T},T}, state::MicroplaneMCCapState{T}
) where {T<:Real}
    return MicroplaneModels.compute_stress_tangent(ε, material, state)
end

function MaterialTestUtils.compute_stress_tangent(
    ε::SymmetricTensor{2,3,T}, material::MicroplaneMaterial{MicroplaneMCDamage{T},T}, state::MicroplaneMCDamageState{T}
) where {T<:Real}
    return MicroplaneModels.compute_stress_tangent(ε, material, state)
end

end # module
