class Pokemon{
	const property vidaMaxima
	
	var property vidaActual = vidaMaxima
	
	var property listaDeMovimientos = []
	
	var property condicionActual = normal
	
	method cambiarCondicion(condicion){
		condicionActual = condicion
	}
	method recibirDanio(perdida){
		vidaActual -= perdida
	}
	method sanarse(cantidad){
		vidaActual = (vidaActual + cantidad).min(vidaMaxima)	
	}
	method estaVivo() = vidaActual > 0
	
	// Punto 1
	
	method poderTotal() = listaDeMovimientos.sum({movimiento => movimiento.poder()})
	
	method grositud() = vidaMaxima * self.poderTotal()
	
	// Punto 2 
	
	
	method movimientoDisponible() = listaDeMovimientos.findOrElse({movimiento =>
 		movimiento.estaDisponible()}, {throw new NoPuedeMoverseException(message = "No tiene movimientos disponibles")})
	
	method usarMovimiento(usuario, rival){
		const movimientoDisponible = self.movimientoDisponible()
		movimientoDisponible.uso(self, rival)
	}
	
	method luchar(rival){
		if(self.estaVivo()){
			if(condicionActual.lograMoverse()){
				self.usarMovimiento(self, rival)
			}else throw new NoPuedeMoverseException (message = "No pudo moverse")
		}else self.error("El pokemon no se encuentra en condiciones de pelear")
	}
}

class Movimientos{
	const property cantidadDeUsosTotales
	
	var property cantidadDeUsosActuales = cantidadDeUsosTotales
	
	method realizarAccion(usuario, rival)
	
	method uso(usuario, rival){
		if(!self.usosAgotados()){
			self.realizarAccion(usuario, rival) 
			self.decrementarUsos()	
		}else {throw new MovimientoAgotadoException(message ="No tiene mas usos de ese movimiento")}
	}
	method decrementarUsos(){
		cantidadDeUsosActuales -= 1
	}
	method restaurarUsos(){
		cantidadDeUsosActuales = cantidadDeUsosTotales
	}
	method estaDisponible() = cantidadDeUsosActuales > 0
	method usosAgotados() = cantidadDeUsosActuales == 0
}

class Curativos inherits Movimientos{
	const property curacion = 0
	
	method poder() = curacion
	
	override method realizarAccion(usuario, rival) = usuario.sanarse(curacion) 
}

class Ofensivos inherits Movimientos{
	const property danio = 0
	
	method poder() = danio*2
	
	override method realizarAccion(usuario, rival) = rival.recibirDanio(danio)
}

class Especiales inherits Movimientos{
	const property tipoDeCondicion
	
	override method realizarAccion(usuario, rival) = rival.cambiarCondicion(tipoDeCondicion)
}

	//------------------ Condiciones ------------------ 

class Condicion{
	method poder()
	
	method intentaMoverse(pokemon){
		if(!self.lograMoverse()){
			throw new NoPuedeMoverseException(message = "No pudo realizar el movimiento")
		}
	}
	method lograMoverse() = 0.randomUpTo(2).roundUp().even()
}

object normal{
	
}

object paralisis inherits Condicion{
	override method poder() = 30
}

object suenio inherits Condicion{
	override method poder() = 50
	
	override method intentaMoverse(pokemon){
		super(pokemon)
		pokemon.cambiarCondicion(normal)
	}
}

// Punto 3 

class Confusion inherits Condicion{
	const property duracion = 0
	
	override method poder() = duracion * 40
	
	override method intentaMoverse(pokemon){
		
	}
}

///////// EXCEPCIONES

class MovimientoAgotadoException inherits Exception {}
class NoPuedeMoverseException inherits Exception {}