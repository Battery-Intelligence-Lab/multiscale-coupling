# Multiscale coupling of surface temperature with solid diffusion in large lithium-ion pouch cells

This repository contains the battery parameterization codes in MATLAB and Comsol for our paper [Multiscale coupling of surface temperature with solid diffusion in large lithium-ion pouch cells](https://www.nature.com/articles/s44172-022-00005-8), also available on [arXiv](https://arxiv.org/abs/2109.12903). The data associated with this paper may be downloaded from [Oxford Research Archive](https://ora.ox.ac.uk/objects/uuid:5f4abb09-c993-4799-9cb1-980218bde513).

We developed a new computationally efficient three-dimensional battery electrochemical-thermal model to parameterize several Li-ion battery physicochemical properties by fitting a model to measured cell surface temperature distributions, current and voltage. This work shows that the surface-temperature distribution across a large-format cell is an effective probe for battery diagnostics.

## Experiments

Lock-in thermography experiments were conducted to measure the surface temperatures of 20 Ah LFP pouch cells synchronously with their voltage output under square-wave applied currents. Cells were cycled galvanostatically, alternating between charge and discharge periods of equal length for the 2500 s duration of the experiment. The applied current was set at 2C or 4C, with periods of 50 s or 100 s for one charge/discharge cycle.

## Parameterization

A reduced-order battery electrochemical-thermal model was derived by simplifying the Doyle--Fuller--Newman (DFN) model to simulate the cell temperature and voltage responses (full details are in the paper). Following this, a multi-objective optimization algorithm was used to parameterize several battery physicochemical properties, including ionic condutivity, exchange current density, solid-phase diffusivity, heat capacity, thermal conductivity, etc. 

## Using the code

The optimization algorithm was implemented in MATLAB which calls the battery model for numerical simulation in COMSOL. To run these codes you will need to have a copy of Matlab and a copy of Comsol include the Livelink module to enable communication betwen Comsol and Matlab. Note that if you are struggling to get up and running it may be to do with changes in Matlab and/or Comsol versions between when we did this work (around 2020-21) and newer software versions. See the issues page.

The main scripts are `Main_Opt.m`, `ObjFunc.m` and `Battery_model.m`, and they are described as follows:
- **Main_Opt**: Defines the nonliear least-squares optimization code for battery parameterization.
- **ObjFunc**: Loads experimental data and simulation results from the battery model to calculate the objective function.
- **Battery_model**: A reduced-order battery electrochemical-thermal model developed in COMSOL and exported as a `.m` file, to be run with COMSOL livelink and MATLAB.

In addition to the scripts, a small example set of experimental data is also provided for fitting. The full set may be downloaded from ORA, see details above.

## Some notes on things that have come up as others have tried this code
- Please be aware that some parameters have been *rescaled* as part of the homogenisation process (notably, $\kappa$ and $\alpha$). The scaling factor is $N^2$, where $N$ is the number of layers in the cell. The explanation of this rescaling is given in section 4.2 of [this paper](https://www.sciencedirect.com/science/article/pii/S0378775320300902) (open access version [here](https://ora.ox.ac.uk/objects/uuid:1e9db630-0d2b-4080-9bce-990067a5bccf)).
