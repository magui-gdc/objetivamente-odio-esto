class Empleado{
	var property salud = 100
	var property habilidades = []
	var puesto
	method saludCritica()
	method incapacitado() = puesto.saludCritica() > salud
	method puedeUsarHabilidad(habilidad)= self.poseeHabilidad(habilidad) and not self.incapacitado()
	method poseeHabilidad(habilidad) = habilidades.contain(habilidad)
}	

class Oficinista {
	var property estrellas = 0
	method saludCritica() = 0.min(40-5*estrellas)
	method ganarEstrella() = estrellas++
}

object espia{ 
	method saludCritica() = 15
}

class Jefe inherits Empleado{
	var property subordinados = []
	override method poseeHabilidad(habilidad) = habilidades.contain(habilidad) or self.algunSubordinadoPoseeHabilidad(habilidad)
	method algunSubordinadoPoseeHabilidad (habilidad) = subordinados.any(subordinados.poseeHabilidad(habilidad))
}


class Mision{
	var property habilidadesNecesarias = []
	var peligrosidad
}



