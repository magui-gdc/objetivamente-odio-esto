class Expedicion{
	var property vikingos = []
	
	var property lugaresDeExpedicion = []
	
	method sumarAExpedicion(vikingo) = vikingos.add(vikingo) 
	
	method cantidadDeVikingos() = vikingos.size()
	
	method valeLaPena() = lugaresDeExpedicion.all({lugar => lugar.valeLaPena(self)})
	
	method aumentarVictimas(cantidad) = vikingos.forEach({vikingo => vikingo.aumentarVictimas(1)})

	method repartirBotin(lugar){
		const parteDeCadaUno = lugar.botin(self).div(self.cantidadDeVikingos())
		vikingos.forEach({vikingo => vikingo.ganarOro(parteDeCadaUno)})
	}
	method saquearLugares() = if(self.valeLaPena()) lugaresDeExpedicion.forEach({lugar => lugar.serSaqueado(self)}) else throw new NoValeLaPenaException(message = "La expedicion no vale la pena")
}

class Vikingo{
	var property castaSocial
	var property victimasFatales = 0
	var property armas = 0
	var property ocupacion
	var oro = 0
	
	method tieneArmas() = armas > 0
	
	method equiparArmas(cantidad){
		armas += cantidad
	}
	
	// Pre Expedicion
	
	method esProductivo() = ocupacion.esProductivo(self)

	method admitidoParaExpedicion() = castaSocial.puedeIrDeExpedicion(self) and self.esProductivo()
	
	method unirseAExpedicion(expedicion){
		if(self.admitidoParaExpedicion()){
			expedicion.sumarAExpedicion(self)
		}
	}
		
	// Post Expedicion

	method aumentarVictimas(cantidad){
		victimasFatales += cantidad
	}
	method ganarOro(cantidad){
		oro += cantidad
	}
	
	// Escalar socialmente
	
	method ascender() = castaSocial.ascender(self)

	method cambiarDeCastas(nuevaCasta){
		castaSocial = nuevaCasta
	}
}

// Ocupaciones 

class Ocupacion{
	method esProductivo(vikingo)
	method ascender(vikingo)
}

object soldado inherits Ocupacion{
	override method esProductivo(vikingo) = vikingo.victimasFatales() > 20 && vikingo.tieneArmas()
	
	override method ascender(vikingo) = vikingo.equiparArmas(10)
}

class Granjero inherits Ocupacion{
	var property cantidadDeHijos = 0
	var property cantidadDeHectareas = 0
	
	method sumarHijos(cantidad){
		cantidadDeHijos += cantidad
	}
	method sumarHectareas(cantidad){
		cantidadDeHectareas += cantidad
	}
	override method esProductivo(vikingo) = (cantidadDeHectareas.div(cantidadDeHijos)) >= 2
	
	override method ascender(vikingo){
		self.sumarHijos(2)
		self.sumarHectareas(2)
	}
}

// castaSocial

class CastaSocial{
	method ascender(vikingo)
	method puedeIrDeExpedicion(vikingo)
}

object jarl inherits CastaSocial{
	override method ascender(vikingo){
		vikingo.ocupacion().ascender(vikingo)
		vikingo.cambiarDeCastas(karl)
	}
	override method puedeIrDeExpedicion(vikingo) = !vikingo.tieneArmas()
}

object karl inherits CastaSocial{
	override method ascender(vikingo) = vikingo.cambiarDeCastas(thrall)
	override method puedeIrDeExpedicion(vikingo){}
}

object thrall inherits CastaSocial{
	override method ascender(vikingo){}
	override method puedeIrDeExpedicion(vikingo){}
}

// Capitales y aldeas

class Capital{
	var factorDeRiqueza
	var property defensores = 0
	
	method defensoresDerrotados(expedicion) = defensores - expedicion.cantidadDeVikingos()
	
	method botin(expedicion) = if(factorDeRiqueza > 0) self.defensoresDerrotados(expedicion) ** factorDeRiqueza else self.defensoresDerrotados(expedicion) + factorDeRiqueza
		
	method valeLaPena(expedicion) = (self.botin(expedicion) / expedicion.cantidadDeVikingos()) >= 3
	
	method serSaqueado(expedicion){
		defensores -= self.defensoresDerrotados(expedicion)
		expedicion.aumentarVictimas(1)
		expedicion.repartirBotin(self)
	}
}

class Aldea{
	var property cantidadDeCrucifijos
	
	method botin(expedicion) = cantidadDeCrucifijos
	
	method valeLaPena(expedicion) = cantidadDeCrucifijos >= 15
	
	method serSaqueado(expedicion){
		expedicion.repartirBotin(self)
		cantidadDeCrucifijos = 0
	} 
}

class AldeaAmurallada inherits Aldea{
	const property minimoDeVikingos
	
	override method valeLaPena(expedicion) = if(expedicion.cantidadDeVikingos() > minimoDeVikingos) super(expedicion) else throw new NoValeLaPenaException(message = "La expedicion no cuenta con la cantidad necesaria de vikingos ")
}


// EXCEPCIONES

class NoValeLaPenaException inherits Exception{}
class NoEsAptoParaExpedicionException inherits Exception{}