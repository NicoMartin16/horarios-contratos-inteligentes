
import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ContractTransactionResponse } from "ethers";
import hre from "hardhat";

describe("GestionMateriasContract", () => {

    async function deployGestionMateriasContractFixture() {
        const GestionMateriasContract = await hre.ethers.getContractFactory("GestionMateriasContract");
        const gestionMateriasContract = await GestionMateriasContract.deploy();
        const materiaCreada = await gestionMateriasContract.crearMateria("Calculo integral", "Se estudian los principios del calculo integral", 3);

        return { gestionMateriasContract, materiaCreada };
    }
    
    describe("Deployment", () => {
        it("Debe crear una nueva materia", async () => {
            // Arrange
            const { materiaCreada } = await loadFixture(deployGestionMateriasContractFixture);
            // assert
            expect(materiaCreada).to.be.ok;
        });
        
        it("Debe obtener una materia por id", async () => {
            //Arrange
            const { gestionMateriasContract } = await loadFixture(deployGestionMateriasContractFixture);
            await gestionMateriasContract.crearMateria("Calculo integral", "Se estudian los principios del calculo integral", 3);
            // Act
            const result = await gestionMateriasContract.obtenerMateria(1);
            // Assert
            expect(result[0]).to.equal("Calculo integral");
            expect(result[1]).to.equal("Se estudian los principios del calculo integral");
            expect(result[2]).to.equal(3);
            expect(result[3]).to.be.true;
        });

        it("Debe actualizar una materia por id", async () => {
            //Arrange
            const { gestionMateriasContract } = await loadFixture(deployGestionMateriasContractFixture);
            await gestionMateriasContract.crearMateria("Calculo integral", "Se estudian los principios del calculo integral", 3);
            // Act
            const result = await gestionMateriasContract.actualizarMateria(1, "Fundamentos de calculo integral", "Se estudian los principios del calculo integral", 3);
            // Assert
            expect(result).to.be.ok;
        });

        it("Debe listar las materias creadas", async () => {
            //Arrange
            const { gestionMateriasContract } = await loadFixture(deployGestionMateriasContractFixture);
            await gestionMateriasContract.crearMateria("Calculo diferencial", "Se estudian los principios del calculo diferencial", 3);
            await gestionMateriasContract.crearMateria("Calculo vectorial", "Se estudian los principios del calculo vectorial", 3);
            await gestionMateriasContract.crearMateria("Calculo avanzado", "Se estudian los principios del calculo avanzado", 3);
            // Act
            const result = await gestionMateriasContract.listarMaterias();
            // Assert
            expect(result).to.be.an("array").that.has.lengthOf(3);
            expect(result[0]).to.equal(1);
            expect(result[1]).to.equal(2);
            expect(result[2]).to.equal(3);
        });

        it("Debe eliminar una materia por id", async () => {
            // Arrange
            const { gestionMateriasContract } = await loadFixture(deployGestionMateriasContractFixture);
            await gestionMateriasContract.crearMateria("Calculo diferencial", "Se estudian los principios del calculo diferencial", 3);
            // Act
            const result = await gestionMateriasContract.eliminarMateria(1);
            const materia = await gestionMateriasContract.obtenerMateria(1);
            // Assert
            expect(materia[3]).to.be.false;
        });

        it("Debe agrerar un horario a una materia dada por id", async () => {
            // Arrange
            const { gestionMateriasContract } = await loadFixture(deployGestionMateriasContractFixture);
            await gestionMateriasContract.crearMateria("Calculo diferencial", "Se estudian los principios del calculo diferencial", 3);
            // Act
            await gestionMateriasContract.agregarHorario(1, 1, 8, 10);
            const materia = await gestionMateriasContract.obtenerMateria(1);
            expect(materia[4]).to.equal(1);
            // Assert
        });

        it("Debe obtener un horario por id de materia y id de horario", async () => {
            //Arrange
            const { gestionMateriasContract } = await loadFixture(deployGestionMateriasContractFixture);
            await gestionMateriasContract.crearMateria("Calculo diferencial", "Se estudian los principios del calculo diferencial", 3);
            await gestionMateriasContract.agregarHorario(1, 1, 8, 10);
            const materia = await gestionMateriasContract.obtenerMateria(1);
            // Act
            const result = await gestionMateriasContract.obtenerHorario(1, 1);
            // Assert
            expect(result[0]).to.equal(1);
            expect(result[1]).to.equal(8);
            expect(result[2]).to.equal(10);
        });

    });
});