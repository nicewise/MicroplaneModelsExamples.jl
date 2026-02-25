# MicroplaneModelsExamples

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Examples and MaterialTestUtils adapter for MicroplaneModels.

## Purpose

This package is for **verifying and testing microplane material models**. It provides:
- Adapter to make `MicroplaneMaterial` work with the `MaterialTestUtils` interface
- Example scripts for testing various microplane models
- Convergence logs documenting test results

## Upstream Dependencies

This package depends on two local packages in the home directory:

- `~/MicroplaneModels.jl` - Core microplane material models
- `~/MaterialTestUtils.jl` - Material testing utilities

## Examples

The `examples/` directory contains test scripts for different microplane models:

- `elastic/` - Elastic material model
- `elastic_damage/` - Elastic-damage material model  
- `mc/` - Microplane Mohr-Coulomb model
- `mc_cap/` - Microplane Mohr-Coulomb with cap model
- `mc_damage/` - Microplane Mohr-Coulomb with damage model (includes MC vs MC-Damage comparison)

Each example includes uniaxial and triaxial test simulations.

## Requirements

- Julia 1.10 or later
- MicroplaneModels.jl (`~/MicroplaneModels`)
- MaterialTestUtils.jl (`~/MaterialTestUtils`)
- Tensors.jl

## Author

sunhh

## License

MIT License
