class Empleado{
	var property salud
	var property saludCritica
	var property habilidades = new Set()
	
	method incapacitado(){
		return salud < saludCritica
	}
	
	method puedeUsarHabilidad(habilidad){
		return habilidades.contain(habilidad) and not(self.incapacitado())
	}
}

class Jefe inherits Empleado{
	
	var property subordinados = new Set()
	
}

class Mision{
	var property habilidades = new Set()
}

