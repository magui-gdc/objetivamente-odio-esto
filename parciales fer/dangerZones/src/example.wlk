class Empleado{
	var property habilidades = #{}
	
	var property salud
	
	var property rol
	
	var property equipo = null
	
	method establecerEquipo(equipoNuevo){
		equipo = equipoNuevo
	}
	
	method recibirDanio(cantidad){
		salud -= cantidad
	}
	method estaVivo() = salud > 0
	
	method aprenderHabilidad(habilidad){
		habilidades.add(habilidad)
	}
	
	// Punto 1
	
	method estaIncapacitado() = salud < rol.saludCritica()

	// Punto 2
	
	method poseeHabilidad(habilidad) = habilidades.contains(habilidad)
	
	method puedeUsarHabilidad(habilidad) = self.poseeHabilidad(habilidad) && !self.estaIncapacitado()
	
	// Punto 3
	
	method puedeRealizarMision(mision) = mision.habilidadesNecesarias().all({habilidad => self.puedeUsarHabilidad(habilidad)})

	method recibirRecompensa(mision){
		if(self.estaVivo()){
			rol.recibirRecompensa(mision, self) 
		}
	}
	
	method cumplirMision(mision){
		if(self.puedeRealizarMision(mision)) {
			self.recibirDanio(mision.peligrosidad())
			self.recibirRecompensa(mision)
		}else self.error("No se pudo cumplir la mision")
	}
}

	//--------------------- Desarrollo de Jefe --------------------- 

class Jefe inherits Empleado{
	var property subordinados = []

	method aniadirSubordinados(empleado){
		subordinados.add(empleado)
	}
	
	// Punto 2 (Jefe)
	
	method unSubordinadoPoseeHabilidad(habilidad) = subordinados.any({empleado => empleado.puedeUsarHabilidad(habilidad)})
	
	override method puedeUsarHabilidad(habilidad) = self.unSubordinadoPoseeHabilidad(habilidad) or super(habilidad)	
}
	
	//--------------------- Desarrollo de Espia --------------------- 

object espia{
	method saludCritica() = 15
	
	method recibirRecompensa(mision, empleado){
		mision.habilidadesNecesarias().forEach({habilidad => empleado.aprenderHabilidad(habilidad)})
	}
}

	//--------------------- Desarrollo de Oficinista --------------------- 

class Oficinista{
	var property cantidadDeEstrellas = 0
	
	method ganarEstrella(){
		cantidadDeEstrellas	+= 1
	}
	method saludCritica() = 40 - 5 * self.cantidadDeEstrellas()
	
	method recibirRecompensa(mision, empleado){
		self.ganarEstrella()	
	}
	method puedeAscenderAEspia() = cantidadDeEstrellas >= 3
		
}

	//--------------------- Desarrollo de Misiones ---------------------
	
class Mision{
	var property habilidadesNecesarias = []
	
	var property peligrosidad
} 

	//--------------------- Desarrollo de Equipo ---------------------

class Equipo{
	const property escuadron = [] 
	
	method aniadirAEscuadron(empleado){
		escuadron.add(empleado)
		empleado.establecerEquipo(self)
	}
	method puedeRealizarMision(mision) = mision.habilidadesNecesarias().all({habilidad => escuadron.any({empleado => empleado.puedeUsarHabilidad(habilidad)})})
	
	method cumplirMision(mision){
		if(self.puedeRealizarMision(mision)){
			escuadron.forEach({empleado => 
				empleado.recibirDanio(mision.peligrosidad()/3)
				empleado.recibirRecompensa(mision)
			})
		}else self.error("No se pudo cumplir la mision")
	}
}
