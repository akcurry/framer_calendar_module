#Calendar Maker

exports.create = (layer) ->
	days = 7
	weeks = 5
	dayWidth = 72
	alert 'oh fuck!' if layer.width < dayWidth * 7
	dayHeight = 30
	marginTop = 15
	distanceFromOutline = 85
	daysInMonth = 31

	selected = -20
	lastSelected = -20
	currentLeft = -20
	currentRight = -20

	range = 2

	trueParent = new Layer
		width: 531
		backgroundColor: 'transparent'
		parent: layer

	dateCardParent = new Layer
		y: 85
		borderWidth: 0
		borderColor: "rgba(121,121,121,1)"
		width: 7 * dayWidth
		height: (weeks * (dayHeight + marginTop)) + distanceFromOutline
		backgroundColor: "rgba(123,123,123,0)"
		borderRadius: 10
		shadowX: 2
		shadowY: 2
		shadowBlur: 6
		parent: trueParent

	Artboard = new Layer
		height: 52
		image: "modules/images/Artboard.png"
		width: 1012
		scale: 0.5
		parent: dateCardParent
		x: -253
		y: 5

	count = 0
	for day in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
		dayTitle = new Layer
			parent: dateCardParent
			backgroundColor: 'transparent'
			y: distanceFromOutline - 35
			x: count * dayWidth
			width: dayWidth
			height: 30
			html: "<p>" + day + "</p>"
			style:
				"fontFamily" : "Akkurat Std"
				"fontWeight" : "bold"
				"fontSize" : "18px"
				"textAlign" : "center"
				"lineHeight" : 30 + "px"
				"color" : "black"
			count++

	dateCards = []

	[0..weeks].map (week) ->
		[0...days].map (day)->
			date = (week * 7 + day + 1)
			if date <= daysInMonth
				daysBefore = - range
				daysAfter = range
				if day < 3
					daysBefore -= 2
				if day > 3
					daysAfter += 2

				dateCard = new Layer
					parent: dateCardParent
					width: dayWidth
					height: dayHeight
					backgroundColor: 'transparent'
					x: day * dayWidth
					y: (week * (dayHeight + marginTop)) + distanceFromOutline
					name: week + "_" + day
					html: "<p>" + date + "</p>"
					style:
						"fontFamily" : "Akkurat Std"
						"fontSize" : "18px"
						"textAlign" : "center"
						"lineHeight" : String(dayHeight) + "px"
						"color" : "black"
					animationOptions:
						time: 0

				if day == 0 or day == 6
					dateCard.style =
						"color" : "grey"

				dateCard.states.add
					selected:
						backgroundColor : 'DAD4C8'
					inRange:
						backgroundColor: '#DAD4C8'
					hover:
						backgroundColor: 'lightgrey'
					hoverRange:
						backgroundColor: 'lightgrey'
					hoverInRange:
						backgroundColor: '#DAD4C8'

				if day > 0 and day < 6
					dateCard.onTap ->
						lastSelected = selected
						nameSplit = @.name.split("_")
						index = (parseInt(nameSplit[0]) * 7) + parseInt(nameSplit[1])

						if lastSelected == index
							selected = - 20
							currentLeft = - 20
							currentRight = -20
							header.html = "<p>Please select a day</p>"
							lowerCopy.opacity = 0

						else
							selected = index
							currentLeft = selected + daysBefore
							currentRight = selected + daysAfter
						selector()

					dateCard.onMouseOver ->
						nameSplit = @.name.split("_")
						hoverID = (parseInt(nameSplit[0]) * 7) + parseInt(nameSplit[1])
						for i in [daysBefore..daysAfter]
							current = hoverID + i
							if current < currentLeft or current > currentRight
								if current == hoverID
									dateCards[current].states.switch('hover')
								else
									if dateCards[current]
										dateCards[current].states.switch('hoverRange')
							else
								if current == hoverID and current != selected
									dateCards[current].states.switch('hoverInRange')

					dateCard.onMouseOut ->
						nameSplit = @.name.split("_")
						hoverID = (parseInt(nameSplit[0]) * 7) + parseInt(nameSplit[1])
						for i in [daysBefore..daysAfter]
							current = hoverID + i
							if current < currentLeft or current > currentRight
								if dateCards[current]
									dateCards[current].states.switch('default')

							else
								if current == hoverID and current != selected
									dateCards[current].states.switch('inRange')

				dateCards.push(dateCard)

	selectedCircles = []
	whiteTexts = []

	for date in dateCards
		dateTextSplitter = date.name.split("_")
		dateText = parseInt(dateTextSplitter[0]) * 7 + parseInt(dateTextSplitter[1]) + 1

		selectedCircle = new Layer
			height: dayHeight + marginTop
			width: dayHeight + marginTop
			borderRadius:(dayHeight + marginTop) / 2
			x: Align.center
			y: Align.center
			opacity: 1
			parent: date
			backgroundColor: "#232E39"
			scale: 0
			shadowX: 2
			shadowY: 1
			shadowBlur: 5
			shadowSpread: 1
			shadowColor: "rgba(123,123,123,0.59)"
			animationOptions:
				time: .4
				curve: Spring

		selectedCircle.states.add
			selected:
				scale: 1

		whiteText = new Layer
			width: dayHeight
			height: dayHeight
			html: "<p>" + dateText + "</p>"
			backgroundColor: 'transparent'
			x: Math.abs(dayHeight - dayWidth) / 2
			parent: date
			opacity: 0
			animationOptions:
				time: 0

		whiteText.states.add
			selected:
				opacity: 1

		whiteTexts.push(whiteText)

		selectedCircles.push(selectedCircle)

	selector = ->
		for i in [0...dateCards.length]
			if i < currentLeft or i > currentRight
				dateCards[i].states.switch('default')
				selectedCircles[i].states.switch('default')
				whiteTexts[i].states.switch('default')
			else if i != selected
				dateCards[i].states.switch('inRange')
			else
				lowerCopy.opacity = 1
				if selected == 1
					header.html = "<p>You have selected <b>March " + (selected + 1)  + "nd</b>"
				else if selected == 2
					header.html = "<p>You have selected <b>March " + (selected + 1)  + "rd</b>"
				else
					header.html = "<p>You have selected <b>March " + (selected + 1)  + "th</b>"
				dateCards[i].states.switch('selected')
				selectedCircles[i].states.switch('selected')
				whiteTexts[i].states.switch('selected')
				if selectedCircles[lastSelected]
					selectedCircles[lastSelected].states.switch('default')
					whiteTexts[lastSelected].states.switch('default')

	header = new Layer
		height: 40
		y: -42
		parent: dateCardParent
		html: "<p>Please select a day</p>"
		backgroundColor: 'transparent'
		width: 472
		x: 2
		style:
			"fontFamily" : "Akkurat Std"
			"color" : "black"
			"fontSize" : "18px"

	description = new Layer
		html: "<p>When would you like your next trunk by?</p>"
		backgroundColor:  'transparent'
		parent: dateCardParent
		y: -70
		width: 432
		height: 28
		style:
			"fontFamily" : "Akkurat Std"
			"color" : "black"
			"fontSize" : "21px"
			"fontWeight" : 'bold'

	lowerCopy = new Layer
		parent: dateCardParent
		width: 468
		html: "<p>The highlighted range shows when to expect your trunk to arrive.</p>"
		y: 327
		style:
			"fontFamily" : "Akkurat Std"
			"color" : "grey"
			"fontSize" : "18px"
		backgroundColor: 'transparent'
		opacity: 0
