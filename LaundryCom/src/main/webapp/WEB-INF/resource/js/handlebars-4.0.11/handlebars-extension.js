var handlebarsVariable = {};

Handlebars.registerHelper('iff', function ($a, $operator, $b, options) {
	var bool = false;
	switch ($operator) {
		case '==':
			bool = $a == $b;
			break;
		case '!=':
			bool = $a != $b;
			break;
		case '>':
			bool = $a > $b;
			break;
		case '>=':
			bool = $a >= $b;
			break;
		case '<':
			bool = $a < $b;
			break;
		case '<=':
			bool = $a <= $b;
			break;
		case '%':
			if($a % $b == 0){
				bool = true;
			}else{
				bool = false;
			}
			break;
		default:
			throw "Unknown operator " + $operator;
	}

	if (bool) {
		return options.fn(this);
	} else {
		return options.inverse(this);
	}
});

var pageIndex = 0;
Handlebars.registerHelper('pageIndex', function ($total, $page, $row, options) {
	pageIndex = $total - ($page - 1) * $row;
});

Handlebars.registerHelper('getPageIndex', function (options) {
	return pageIndex--;
});

Handlebars.registerHelper('isNull', function ($value, options) {
	var bool = false;
	if ($value && $value != "" && $value != {}) {
		bool = true;
	}

	if (!bool) {
		return options.fn(this);
	} else {
		return options.inverse(this);
	}
});

Handlebars.registerHelper('isNotNull', function ($value, options) {
	var bool = true;
	if (!($value && $value != "" && $value != {})) {
		bool = false;
	}

	if (bool) {
		return options.fn(this);
	} else {
		return options.inverse(this);
	}
});
Handlebars.registerHelper('console', function ($value) {
	console.log($value);
});
Handlebars.registerHelper('set', function ($key, $value) {
	handlebarsVariable[$key] = $value;
});
Handlebars.registerHelper('get', function ($key, options) {
	return handlebarsVariable[$key];
});
Handlebars.registerHelper('array', function ($array, $index) {
	return $array[$index];
});
Handlebars.registerHelper('displayDate', function ($time) {
	return displayDate($time, "yyyy.MM.dd");
});
Handlebars.registerHelper('displayTimestamp', function ($time) {
	return displayTimestamp($time);
});
Handlebars.registerHelper('displayNumber', function ($number) {
	return String($number).replace(/\B(?=(\d{3})+(?!\d))/g, ",");
});
Handlebars.registerHelper('documentDate', function ($date) {
	if ($date ==null || $date == "") {
		return "";
	}else{
		return $date.substring(0,4)+"."+$date.substring(4,6)+"."+$date.substring(6,8)
	}
});
Handlebars.registerHelper('expireDate', function ($text) {
	if ($text ==null || $text == "") {
		return "";
	}else{
		var expireTimestamp = $text;
		var expireDate = new Date(expireTimestamp);
		//expireDate = formatDate(expireDate);
		var d = new Date(expireDate), month = '' + (d.getMonth() + 1),
			day = '' + d.getDate(), year = d.getFullYear();
		if (month.length < 2) month = '0' + month;
		if (day.length < 2) day = '0' + day;

		return [year, month, day].join('-');
	}
});

Handlebars.registerHelper('getUserGrade', function ($value) {
	if($value == 1)
		return "시스템 관리자";
	else if($value == 2)
		return "관리자";
	else
		return "사용자";
});

Handlebars.registerHelper('selected', function ($option, $value) {
	if($option == $value)
		return "selected";
});
Handlebars.registerHelper('checked', function ($option, $value) {
	if($option = $value)
		return "checked";
});

Handlebars.registerHelper('indexing', function ($value, $page) {
	return ($value + 1) + 5 * ($page-1);
});
Handlebars.registerHelper('indexing10', function ($value, $page) {
	return ($value + 1) + 10 * ($page-1);
});

Handlebars.registerHelper('substring', function ($text, $start, $end) {
	if (!$text) {
		return "";
	}
	if ($text.length < $end) {

		return $text;
	}
	return $text.substring($start, $end);
});
Handlebars.registerHelper('positionalNumber', function ($number) {
	return Math.round($number * 100) / 100;
});
Handlebars.registerHelper('defaultValue', function ($value, $defaultValue) {
	var value = $.trim($value);
	if (value != undefined || value != null || value != "") {
		return $value;
	}
	return $defaultValue;dd
});

/*
	 time 값을 Date 형태로 변환
	 Long   $time(필수) : time
	 String $format    : 포맷 지정 (JAVA의 SimpleDateFormat과 동일)
	 String return     : 변환된 날짜
	 */

function displayDate($time, $format) {
	if (!Utils.hasValue($time)) {
		return "";
	}
	if (!Utils.hasValue($format)) {
		$format = "yyyy-MM-dd";
	}
	var date = new Date($time);
	var format = new SimpleDateFormat($format);
	return format.format(date);
}
/*
 time 값을 Timestamp 형태로 변환
 Long   $time(필수) : time
 String $format    : 포맷 지정 (JAVA의 SimpleDateFormat과 동일)
 String return     : 변환된 날짜
 */
function displayTimestamp($time, $format) {
	if (!Utils.hasValue($time)) {
		return "";
	}
	if (!Utils.hasValue($format)) {
		$format = "yyyy-MM-dd HH:mm:ss";
	}
	var date = new Date($time);
	var format = new SimpleDateFormat($format);
	return format.format(date);
}

Handlebars.registerHelper('eachInMap', function (map, block) {
	var out = '';
	Object.keys(map).map(function (prop) {
		out += block.fn({key: prop, value: map[prop]});
	});
	return out;
});

Handlebars.registerHelper('comma', function ($value) {
	$value = String($value);
    return $value.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
});