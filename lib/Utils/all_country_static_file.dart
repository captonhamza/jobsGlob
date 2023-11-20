import 'dart:convert';

import '../Models/countryModel.dart';

String AllCountryListJosn = '''
{
   
    "data": [
        {
            "id": 1,
            "country_name": "Japan"
        },
        {
            "id": 2,
            "country_name": "Indonesia"
        },
        {
            "id": 3,
            "country_name": "India"
        },
        {
            "id": 4,
            "country_name": "Philippines"
        },
        {
            "id": 5,
            "country_name": "Brazil"
        },
        {
            "id": 6,
            "country_name": "South Korea"
        },
        {
            "id": 7,
            "country_name": "China"
        },
        {
            "id": 8,
            "country_name": "Mexico"
        },
        {
            "id": 9,
            "country_name": "Egypt"
        },
        {
            "id": 10,
            "country_name": "United States"
        },
        {
            "id": 11,
            "country_name": "Russia"
        },
        {
            "id": 12,
            "country_name": "Thailand"
        },
        {
            "id": 13,
            "country_name": "Bangladesh"
        },
        {
            "id": 14,
            "country_name": "Argentina"
        },
        {
            "id": 15,
            "country_name": "Nigeria"
        },
        {
            "id": 16,
            "country_name": "Turkey"
        },
        {
            "id": 17,
            "country_name": "Pakistan"
        },
        {
            "id": 18,
            "country_name": "Congo (Kinshasa)"
        },
        {
            "id": 19,
            "country_name": "Vietnam"
        },
        {
            "id": 20,
            "country_name": "Iran"
        },
        {
            "id": 21,
            "country_name": "United Kingdom"
        },
        {
            "id": 22,
            "country_name": "France"
        },
        {
            "id": 23,
            "country_name": "Peru"
        },
        {
            "id": 24,
            "country_name": "Angola"
        },
        {
            "id": 25,
            "country_name": "Malaysia"
        },
        {
            "id": 26,
            "country_name": "Colombia"
        },
        {
            "id": 27,
            "country_name": "Tanzania"
        },
        {
            "id": 28,
            "country_name": "Hong Kong"
        },
        {
            "id": 29,
            "country_name": "Chile"
        },
        {
            "id": 30,
            "country_name": "Saudi Arabia"
        },
        {
            "id": 31,
            "country_name": "Iraq"
        },
        {
            "id": 32,
            "country_name": "Sudan"
        },
        {
            "id": 33,
            "country_name": "Spain"
        },
        {
            "id": 34,
            "country_name": "Kenya"
        },
        {
            "id": 35,
            "country_name": "Myanmar"
        },
        {
            "id": 36,
            "country_name": "Canada"
        },
        {
            "id": 37,
            "country_name": "Singapore"
        },
        {
            "id": 38,
            "country_name": "Côte d'Ivoire"
        },
        {
            "id": 39,
            "country_name": "Australia"
        },
        {
            "id": 40,
            "country_name": "South Africa"
        },
        {
            "id": 41,
            "country_name": "Morocco"
        },
        {
            "id": 42,
            "country_name": "Afghanistan"
        },
        {
            "id": 43,
            "country_name": "Jordan"
        },
        {
            "id": 44,
            "country_name": "Germany"
        },
        {
            "id": 45,
            "country_name": "Algeria"
        },
        {
            "id": 46,
            "country_name": "Bolivia"
        },
        {
            "id": 47,
            "country_name": "Ethiopia"
        },
        {
            "id": 48,
            "country_name": "Kuwait"
        },
        {
            "id": 49,
            "country_name": "Ukraine"
        },
        {
            "id": 50,
            "country_name": "Yemen"
        },
        {
            "id": 51,
            "country_name": "Guatemala"
        },
        {
            "id": 52,
            "country_name": "Italy"
        },
        {
            "id": 53,
            "country_name": "North Korea"
        },
        {
            "id": 54,
            "country_name": "Taiwan"
        },
        {
            "id": 55,
            "country_name": "Ecuador"
        },
        {
            "id": 56,
            "country_name": "Madagascar"
        },
        {
            "id": 57,
            "country_name": "Dominican Republic"
        },
        {
            "id": 58,
            "country_name": "United Arab Emirates"
        },
        {
            "id": 59,
            "country_name": "Uzbekistan"
        },
        {
            "id": 60,
            "country_name": "Burkina Faso"
        },
        {
            "id": 61,
            "country_name": "Cameroon"
        },
        {
            "id": 62,
            "country_name": "Ghana"
        },
        {
            "id": 63,
            "country_name": "Azerbaijan"
        },
        {
            "id": 64,
            "country_name": "Zimbabwe"
        },
        {
            "id": 65,
            "country_name": "Cuba"
        },
        {
            "id": 66,
            "country_name": "Cambodia"
        },
        {
            "id": 67,
            "country_name": "Somalia"
        },
        {
            "id": 68,
            "country_name": "Mali"
        },
        {
            "id": 69,
            "country_name": "Belarus"
        },
        {
            "id": 70,
            "country_name": "Venezuela"
        },
        {
            "id": 71,
            "country_name": "Syria"
        },
        {
            "id": 72,
            "country_name": "Kazakhstan"
        },
        {
            "id": 73,
            "country_name": "Austria"
        },
        {
            "id": 74,
            "country_name": "Malawi"
        },
        {
            "id": 75,
            "country_name": "Romania"
        },
        {
            "id": 76,
            "country_name": "Congo (Brazzaville)"
        },
        {
            "id": 77,
            "country_name": "Poland"
        },
        {
            "id": 78,
            "country_name": "Belgium"
        },
        {
            "id": 79,
            "country_name": "Zambia"
        },
        {
            "id": 80,
            "country_name": "Hungary"
        },
        {
            "id": 81,
            "country_name": "Guinea"
        },
        {
            "id": 82,
            "country_name": "Uganda"
        },
        {
            "id": 83,
            "country_name": "Oman"
        },
        {
            "id": 84,
            "country_name": "Mongolia"
        },
        {
            "id": 85,
            "country_name": "Serbia"
        },
        {
            "id": 86,
            "country_name": "New Zealand"
        },
        {
            "id": 87,
            "country_name": "Czechia"
        },
        {
            "id": 88,
            "country_name": "Uruguay"
        },
        {
            "id": 89,
            "country_name": "Bulgaria"
        },
        {
            "id": 90,
            "country_name": "Honduras"
        },
        {
            "id": 91,
            "country_name": "Mozambique"
        },
        {
            "id": 92,
            "country_name": "Qatar"
        },
        {
            "id": 93,
            "country_name": "Senegal"
        },
        {
            "id": 94,
            "country_name": "Rwanda"
        },
        {
            "id": 95,
            "country_name": "Libya"
        },
        {
            "id": 96,
            "country_name": "Georgia"
        },
        {
            "id": 97,
            "country_name": "Chad"
        },
        {
            "id": 98,
            "country_name": "Denmark"
        },
        {
            "id": 99,
            "country_name": "Armenia"
        },
        {
            "id": 100,
            "country_name": "Mauritania"
        },
        {
            "id": 101,
            "country_name": "Kyrgyzstan"
        },
        {
            "id": 102,
            "country_name": "Tunisia"
        },
        {
            "id": 103,
            "country_name": "Nepal"
        },
        {
            "id": 104,
            "country_name": "Niger"
        },
        {
            "id": 105,
            "country_name": "Nicaragua"
        },
        {
            "id": 106,
            "country_name": "Liberia"
        },
        {
            "id": 107,
            "country_name": "Haiti"
        },
        {
            "id": 108,
            "country_name": "Sweden"
        },
        {
            "id": 109,
            "country_name": "Eritrea"
        },
        {
            "id": 110,
            "country_name": "Sierra Leone"
        },
        {
            "id": 111,
            "country_name": "Laos"
        },
        {
            "id": 112,
            "country_name": "Israel"
        },
        {
            "id": 113,
            "country_name": "Central African Republic"
        },
        {
            "id": 114,
            "country_name": "Panama"
        },
        {
            "id": 115,
            "country_name": "Netherlands"
        },
        {
            "id": 116,
            "country_name": "Togo"
        },
        {
            "id": 117,
            "country_name": "Gabon"
        },
        {
            "id": 118,
            "country_name": "Croatia"
        },
        {
            "id": 119,
            "country_name": "Tajikistan"
        },
        {
            "id": 120,
            "country_name": "Benin"
        },
        {
            "id": 121,
            "country_name": "Sri Lanka"
        },
        {
            "id": 122,
            "country_name": "Norway"
        },
        {
            "id": 123,
            "country_name": "Greece"
        },
        {
            "id": 124,
            "country_name": "Burundi"
        },
        {
            "id": 125,
            "country_name": "Finland"
        },
        {
            "id": 126,
            "country_name": "Macedonia"
        },
        {
            "id": 127,
            "country_name": "Moldova"
        },
        {
            "id": 128,
            "country_name": "Latvia"
        },
        {
            "id": 129,
            "country_name": "Jamaica"
        },
        {
            "id": 130,
            "country_name": "Lithuania"
        },
        {
            "id": 131,
            "country_name": "El Salvador"
        },
        {
            "id": 132,
            "country_name": "Djibouti"
        },
        {
            "id": 133,
            "country_name": "Ireland"
        },
        {
            "id": 134,
            "country_name": "Paraguay"
        },
        {
            "id": 135,
            "country_name": "Portugal"
        },
        {
            "id": 136,
            "country_name": "Slovakia"
        },
        {
            "id": 137,
            "country_name": "Estonia"
        },
        {
            "id": 138,
            "country_name": "Lebanon"
        },
        {
            "id": 139,
            "country_name": "Albania"
        },
        {
            "id": 140,
            "country_name": "Guinea-Bissau"
        },
        {
            "id": 141,
            "country_name": "South Sudan"
        },
        {
            "id": 142,
            "country_name": "Lesotho"
        },
        {
            "id": 143,
            "country_name": "Cyprus"
        },
        {
            "id": 144,
            "country_name": "Namibia"
        },
        {
            "id": 145,
            "country_name": "Papua New Guinea"
        },
        {
            "id": 146,
            "country_name": "Costa Rica"
        },
        {
            "id": 147,
            "country_name": "Slovenia"
        },
        {
            "id": 148,
            "country_name": "Bosnia And Herzegovina"
        },
        {
            "id": 149,
            "country_name": "The Bahamas"
        },
        {
            "id": 150,
            "country_name": "Martinique"
        },
        {
            "id": 151,
            "country_name": "Botswana"
        },
        {
            "id": 152,
            "country_name": "Suriname"
        },
        {
            "id": 153,
            "country_name": "Timor-Leste"
        },
        {
            "id": 154,
            "country_name": "Maldives"
        },
        {
            "id": 155,
            "country_name": "Guyana"
        },
        {
            "id": 156,
            "country_name": "Gibraltar"
        },
        {
            "id": 157,
            "country_name": "Reunion"
        },
        {
            "id": 158,
            "country_name": "Equatorial Guinea"
        },
        {
            "id": 159,
            "country_name": "Montenegro"
        },
        {
            "id": 160,
            "country_name": "Bahrain"
        },
        {
            "id": 161,
            "country_name": "Mauritius"
        },
        {
            "id": 162,
            "country_name": "Curaçao"
        },
        {
            "id": 163,
            "country_name": "Switzerland"
        },
        {
            "id": 164,
            "country_name": "French Polynesia"
        },
        {
            "id": 165,
            "country_name": "Luxembourg"
        },
        {
            "id": 166,
            "country_name": "Iceland"
        },
        {
            "id": 167,
            "country_name": "Cabo Verde"
        },
        {
            "id": 168,
            "country_name": "Barbados"
        },
        {
            "id": 169,
            "country_name": "Comoros"
        },
        {
            "id": 170,
            "country_name": "Bhutan"
        },
        {
            "id": 171,
            "country_name": "Swaziland"
        },
        {
            "id": 172,
            "country_name": "New Caledonia"
        },
        {
            "id": 173,
            "country_name": "Solomon Islands"
        },
        {
            "id": 174,
            "country_name": "Fiji"
        },
        {
            "id": 175,
            "country_name": "Saint Lucia"
        },
        {
            "id": 176,
            "country_name": "French Guiana"
        },
        {
            "id": 177,
            "country_name": "Sao Tome And Principe"
        },
        {
            "id": 178,
            "country_name": "Vanuatu"
        },
        {
            "id": 179,
            "country_name": "Bermuda"
        },
        {
            "id": 180,
            "country_name": "Brunei"
        },
        {
            "id": 181,
            "country_name": "Monaco"
        },
        {
            "id": 182,
            "country_name": "Trinidad And Tobago"
        },
        {
            "id": 183,
            "country_name": "Samoa"
        },
        {
            "id": 184,
            "country_name": "Kiribati"
        },
        {
            "id": 185,
            "country_name": "Aruba"
        },
        {
            "id": 186,
            "country_name": "Jersey"
        },
        {
            "id": 187,
            "country_name": "The Gambia"
        },
        {
            "id": 188,
            "country_name": "Mayotte"
        },
        {
            "id": 189,
            "country_name": "Marshall Islands"
        },
        {
            "id": 190,
            "country_name": "Isle Of Man"
        },
        {
            "id": 191,
            "country_name": "Cayman Islands"
        },
        {
            "id": 192,
            "country_name": "Seychelles"
        },
        {
            "id": 193,
            "country_name": "Saint Vincent And The Grenadines"
        },
        {
            "id": 194,
            "country_name": "Andorra"
        },
        {
            "id": 195,
            "country_name": "Antigua And Barbuda"
        },
        {
            "id": 196,
            "country_name": "Tonga"
        },
        {
            "id": 197,
            "country_name": "Turkmenistan"
        },
        {
            "id": 198,
            "country_name": "Greenland"
        },
        {
            "id": 199,
            "country_name": "Belize"
        },
        {
            "id": 200,
            "country_name": "Dominica"
        },
        {
            "id": 201,
            "country_name": "Saint Kitts And Nevis"
        },
        {
            "id": 202,
            "country_name": "Faroe Islands"
        },
        {
            "id": 203,
            "country_name": "American Samoa"
        },
        {
            "id": 204,
            "country_name": "Malta"
        },
        {
            "id": 205,
            "country_name": "Gaza Strip"
        },
        {
            "id": 206,
            "country_name": "Turks And Caicos Islands"
        },
        {
            "id": 207,
            "country_name": "Federated States of Micronesia"
        },
        {
            "id": 208,
            "country_name": "Tuvalu"
        },
        {
            "id": 209,
            "country_name": "Liechtenstein"
        },
        {
            "id": 210,
            "country_name": "Cook Islands"
        },
        {
            "id": 211,
            "country_name": "Grenada"
        },
        {
            "id": 212,
            "country_name": "San Marino"
        },
        {
            "id": 213,
            "country_name": "West Bank"
        },
        {
            "id": 214,
            "country_name": "Northern Mariana Islands"
        },
        {
            "id": 215,
            "country_name": "Falkland Islands (Islas Malvinas)"
        },
        {
            "id": 216,
            "country_name": "Vatican City"
        },
        {
            "id": 217,
            "country_name": "Niue"
        },
        {
            "id": 218,
            "country_name": "Guadeloupe"
        },
        {
            "id": 219,
            "country_name": "Guam"
        },
        {
            "id": 220,
            "country_name": "Saint Martin"
        },
        {
            "id": 221,
            "country_name": "Saint Helena, Ascension, And Tristan Da Cunha"
        },
        {
            "id": 222,
            "country_name": "Montserrat"
        },
        {
            "id": 223,
            "country_name": "Sint Maarten"
        },
        {
            "id": 224,
            "country_name": "Nauru"
        },
        {
            "id": 225,
            "country_name": "Kosovo"
        },
        {
            "id": 226,
            "country_name": "Saint Barthelemy"
        },
        {
            "id": 227,
            "country_name": "British Virgin Islands"
        },
        {
            "id": 228,
            "country_name": "Palau"
        },
        {
            "id": 229,
            "country_name": "Saint Pierre And Miquelon"
        },
        {
            "id": 230,
            "country_name": "Anguilla"
        },
        {
            "id": 231,
            "country_name": "Wallis And Futuna"
        },
        {
            "id": 232,
            "country_name": "Norfolk Island"
        },
        {
            "id": 233,
            "country_name": "Svalbard"
        },
        {
            "id": 234,
            "country_name": "Pitcairn Islands"
        },
        {
            "id": 235,
            "country_name": "Christmas Island"
        },
        {
            "id": 236,
            "country_name": "South Georgia And South Sandwich Islands"
        },
        {
            "id": 237,
            "country_name": "Macau"
        },
        {
            "id": 238,
            "country_name": "Puerto Rico"
        },
        {
            "id": 239,
            "country_name": "U.S. Virgin Islands"
        }
    ]
}
''';
