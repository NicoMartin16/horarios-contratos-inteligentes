// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

// Uncomment this line to use console.log
import "hardhat/console.sol";

contract GestionMateriasContract {

    enum Rol { Estudiante, Profesor, Administrador }

    struct Usuario {
        address direccion;
        Rol rol;
        bool activo;
    }

    struct Horario {
        uint8 dia;
        uint8 horaInicio;
        uint8 horaFin;
    }

    struct Materia {
        string nombre;
        string descripcion;
        uint creditos;
        bool activa;
        uint totalHorarios;
        mapping(uint => Horario) horarios;
    }

    mapping(uint => Materia) public materias;
    mapping(address => Usuario) public usuarios;
    uint public totalMaterias;

    address public admin;

    event MateriaCreada(uint id, string nombre);
    event MateriaEliminada(uint id);
    event MateriaActualizada(uint id, string nombre);
    event HorarioAgregado(uint id, uint8 dia, uint8 horaInicio, uint8 horaFin);
    event UsuarioRegistrado(address direccion, Rol rol);

    constructor() {
        admin = msg.sender;
        usuarios[msg.sender] = Usuario(msg.sender, Rol.Administrador, true);
    }

    function registrarUsuario(address _usuario, Rol _rol) public {
        require(!usuarios[_usuario].activo, "Usuario ya registrado");
        usuarios[_usuario] = Usuario(_usuario, _rol, true);
        emit UsuarioRegistrado(_usuario, _rol);
    }

    function crearMateria(string memory _nombre, string memory _descripcion, uint _creditos) public {
        uint materiaId = totalMaterias++;
        Materia storage nuevaMateria = materias[materiaId];
        nuevaMateria.nombre = _nombre;
        nuevaMateria.descripcion = _descripcion;
        nuevaMateria.creditos = _creditos;
        nuevaMateria.activa = true;
        nuevaMateria.totalHorarios = 0;
        emit MateriaCreada(totalMaterias,_nombre);
    }

    function obtenerMateria(uint _id) public view returns (string memory, string memory, uint, bool, uint) {
        require(_id >= 0 && _id <= totalMaterias, "ID de materia invalido");

        Materia storage materia = materias[_id];
        return (materia.nombre, materia.descripcion, materia.creditos, materia.activa, materia.totalHorarios);
    }

    function actualizarMateria(uint _id, string memory _nombre, string memory _descripcion, uint _creditos) public {
        require(_id >= 0 && _id <= totalMaterias, "ID de materia invalido");
        require(materias[_id].activa, "La materia no existe o ha sido eliminada");

        Materia storage materia = materias[_id];
        materia.nombre = _nombre;
        materia.descripcion = _descripcion;
        materia.creditos = _creditos;

        emit MateriaActualizada(_id, _nombre);
    }

    function eliminarMateria(uint _id) public {
        require(_id >= 0 && _id <= totalMaterias, "ID de materia invalido");
        require(materias[_id].activa, "La materia no existe o ha sido eliminada");

        materias[_id].activa = false;
        emit MateriaEliminada(_id);
    }

    function listarMaterias() public view returns (uint[] memory) {
        uint[] memory materiasActivas = new uint[](totalMaterias);
        uint contador = 0;

        for (uint i = 1; i < totalMaterias; i++) {
            if(materias[i].activa) {
                materiasActivas[contador] = i;
                contador++;
            }
        }

        uint[] memory resultado = new uint[](contador);
        for (uint i = 0; i < contador; i++) {
            resultado[i] = materiasActivas[i];
        }

        return resultado;
    }

    function agregarHorario(uint _id, uint8 _dia, uint8 _horaInicio, uint8 _horaFin) public {
        require(_id >= 0 && _id <= totalMaterias, "ID de materia invalido");
        require(materias[_id].activa, "La materia no existe o ha sido eliminada");
        require(_dia >= 1 && _dia <= 7, "Dia invalido");
        require(_horaInicio < 24 && _horaFin < 24 && _horaInicio < _horaFin, "Horario invalido");

        Materia storage materia = materias[_id];
        uint horarioId = materia.totalHorarios + 1;
        materia.horarios[horarioId] = Horario(_dia, _horaInicio, _horaFin);
        materia.totalHorarios = horarioId;
        emit HorarioAgregado(_id, _dia, _horaInicio, _horaFin);
    }

    function obtenerHorario(uint _materiaId, uint _horarioId) public view returns (
        uint8,
        uint8,
        uint8
    ) {
        require(_materiaId >= 0 && _materiaId <= totalMaterias, "ID de materia invalido");
        require(materias[_materiaId].activa, "La materia no existe o ha sido eliminada");
        require(_horarioId >= 0 && _horarioId <= materias[_materiaId].totalHorarios, "ID de horario invalido");
        

        Horario storage horario = materias[_materiaId].horarios[_horarioId];
        return (horario.dia, horario.horaInicio, horario.horaFin);
    }
}
