class Persona{
	var property trabajo
	var hijos
	var felicidad = 0
	var property personalidad
	
	// Suenios
	const property sueniosPendientes = []
	const property sueniosCumplidos = []
	
	method totalSueniosPendientes() = sueniosPendientes.size()
	method totalSueniosCumplidos() = sueniosCumplidos.size()
	method totalDeSuenios() = sueniosPendientes + sueniosCumplidos
	
	method cumplirSuenio(suenio) = 	personalidad.cumplirSuenio(self)
	
	method tacharSuenio(suenio){
		sueniosPendientes.remove(suenio)
		sueniosCumplidos.add(suenio)
	}
	
	// Modificar cantidad de hijos
	
	method tenerHijos(cantidad){
		hijos += cantidad
	}
	method tieneHijos() = hijos > 0
	
	// Cambiar de empleo
	
	method conseguirUnTrabajo(trabajoNuevo){
		trabajo = trabajoNuevo
	}
	
	// Aumentar felicidad
	
	method aumentarFelicidad(cantidad){
		felicidad += cantidad
	}
	method esFeliz() = felicidad > sueniosPendientes.sum({suenio => suenio.felicidonios()}) 
	
	method sueniosConFelicidadMayorA(cantidad) = self.totalDeSuenios().sum({suenio => suenio.felicidonios()}) > cantidad
	
	
	method esAmbiciosa() = self.totalDeSuenios().size() > 3 and self.sueniosConFelicidadMayorA(100)
}

// Suenios 

class Suenio{
	const property felicidonios
	
	method noPuedeCumplirse(persona)
	
	method cumplirse(persona){
		if(!self.noPuedeCumplirse(persona)){
			persona.aumentarFelicidad(felicidonios)
			persona.tacharSuenio(self)
		}else throw new NoPuedeCumplirseException(message = "El suenio no puede cumplirse")
	}
}

class SuenioAdoptarHijo inherits Suenio{
	override method noPuedeCumplirse(persona) = persona.tieneHijos()
	
	override method cumplirse(persona){
		super(persona)
		persona.tenerHijos(1)
	}
}

class SuenioUniversitario inherits Suenio{
	override method noPuedeCumplirse(persona) = !persona.sueniosPendientes().contains(self) or persona.sueniosCumplidos().contains(self) 
}

class SuenioLaboral inherits Suenio{
	const property dineroAGanar = 0
	
	override method noPuedeCumplirse(persona) = persona.trabajo().dineroOfrecido() < dineroAGanar
}

class SuenioMultiple inherits Suenio{
	const property suenios = []
	
	override method noPuedeCumplirse(persona) = suenios.all({suenio => suenio.noPuedeCumplirse(persona, suenio)})
	
	override method cumplirse(persona){
		if(!self.noPuedeCumplirse(persona)){
			suenios.forEach({suenio => suenio.cumplirse(persona, suenio)})
		}else throw new NoPuedeCumplirseException(message = "Al menos uno de los suenios no es posible de cumplir")
	}
}

// Tipos de persona

class Personalidad{
	method cumplirSuenio(persona)
}

object obsesivo inherits Personalidad{
	override method cumplirSuenio(persona){
		const primerSuenio = persona.sueniosPendientes().first()
		primerSuenio.cumplirse(persona)
	}
}
class Realista inherits Personalidad{
	const property suenioMasImportante
	
	override method cumplirSuenio(persona){
		suenioMasImportante.cumplirse(persona)
	}
}
object alocado inherits Personalidad{
	override method cumplirSuenio(persona){
		const posicionRandom = 0.randomUpTo(persona.totalSueniosPendientes())
		const suenioEnPosicionRandom = persona.sueniosPendientes().get(posicionRandom)
		suenioEnPosicionRandom.cumplirse(persona)
	}
}


// Otros adicionales

class Trabajo{
	var property dineroOfrecido
}


// EXCEPCIONES 

class NoPoseeEseSuenioException inherits Exception{}
class NoPuedeCumplirseException inherits Exception{}