// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const HorariosModule = buildModule("HorariosModule", (m) => {

  const horarios = m.contract('GestionMateriasContract');

  return {horarios};

});

export default HorariosModule;
