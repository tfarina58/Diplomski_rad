import 'package:diplomski_rad/interfaces/coordinates/coordinates.dart';
import 'package:diplomski_rad/interfaces/estate/estate.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/widgets/card.dart';
import 'package:diplomski_rad/estates/estate-details/estate-details.dart';

class EstatesPage extends StatefulWidget {
  final double cardSize = 800;
  List<CompanyEstate> companyEstates = [
    CompanyEstate(
      id: "c4ca4238a0b923820dcc509a6f75849b",
      companyId: "c81e728d9d4c2f636f067f89cc14862c",
      name: "Rovinj",
      street: "Mattea Benussia 508",
      zip: "52210",
      city: "Rovinj",
      country: "Croatia",
      coordinates: Coordinates(latitude: 13, longitude: 15),
      phone: "+385 99 471 6110",
      templates: -1,
      description: "Villa Paliaga description",
      images: [
        "images/test.png",
        "images/rovinj2.jpg",
        "images/rovinj4.jpg",
        "images/rovinj3.jpg",
        "images/rovinj5.jpg",
        "images/rovinj6.jpg",
        "images/rovinj7.jpg",
      ],
    ),
    CompanyEstate(
      id: "c4ca4238a0b923820dcc509a6f75849b",
      companyId: "c81e728d9d4c2f636f067f89cc14862c",
      name: "Sea apartments",
      zip: "47712",
      city: "Vaitāpē",
      country: "Bora Bora, French Polynesia",
      coordinates: Coordinates(latitude: 13, longitude: 15),
      phone: "+47 86 000 1000",
      templates: -1,
      description: "Sea apartments description",
      images: [
        "images/test2.jpg",
      ],
    ),
    CompanyEstate(
      id: "c4ca4238a0b923820dcc509a6f75849b",
      companyId: "c81e728d9d4c2f636f067f89cc14862c",
      name: "Aphrodite's rock",
      street: "Pissouri 221A",
      zip: "3221",
      city: "Pissouri",
      country: "Cyprus",
      coordinates: Coordinates(latitude: 13, longitude: 15),
      phone: "+357 11 529 4490",
      templates: -1,
      description: "Aphrodite's rock description",
      images: [
        "images/test3.jpg",
      ],
    ),
  ];

  final List<IndividualEstate> individualEstates = [
    IndividualEstate(
      id: "c4ca4238a0b923820dcc509a6f75849b",
      individualId: "c81e728d9d4c2f636f067f89cc14862c",
      name: "Aphrodite's rock",
      street: "Pissouri 221A",
      zip: "3221",
      city: "Pissouri",
      country: "Cyprus",
      coordinates: Coordinates(latitude: 13, longitude: 15),
      phone: "+357 11 529 4490",
      templates: -1,
      description: "Aphrodite's rock description",
      images: [
        "images/test3.jpg",
      ],
    ),
    IndividualEstate(
      id: "c4ca4238a0b923820dcc509a6f75849b",
      individualId: "c81e728d9d4c2f636f067f89cc14862c",
      name: "Sea apartments",
      zip: "47712",
      city: "Vaitāpē",
      country: "Bora Bora, French Polynesia",
      coordinates: Coordinates(latitude: 13, longitude: 15),
      phone: "+47 86 000 1000",
      templates: -1,
      description: "Sea apartments description",
      images: [
        "images/test2.jpg",
      ],
    ),
    IndividualEstate(
      id: "c4ca4238a0b923820dcc509a6f75849b",
      individualId: "c81e728d9d4c2f636f067f89cc14862c",
      name: "Rovinj",
      street: "Mattea Benussia 508",
      zip: "52210",
      city: "Rovinj",
      country: "Croatia",
      coordinates: Coordinates(latitude: 13, longitude: 15),
      phone: "+385 99 471 6110",
      templates: -1,
      description: "Villa Paliaga description",
      images: [
        "images/test.png",
        "images/rovinj2.jpg",
        "images/rovinj4.jpg",
        "images/rovinj3.jpg",
        "images/rovinj5.jpg",
        "images/rovinj6.jpg",
        "images/rovinj7.jpg",
      ],
    ),
  ];

  EstatesPage({Key? key}) : super(key: key);

  @override
  State<EstatesPage> createState() => _EstatesPageState();
}

class _EstatesPageState extends State<EstatesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderComponent(currentPage: 'EstatesPage'),
      body: SizedBox(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 26,
                  width: MediaQuery.of(context).size.width,
                ),
                ...getCards(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    print("Init");

    super.initState();
  }

  List<Widget> getCards() {
    List<Widget> res = [];

    if (widget.individualEstates.isNotEmpty) {
      for (int i = 0; i < widget.individualEstates.length; ++i) {
        res.add(
          Hero(
            tag: widget.individualEstates[i].images[0],
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EstateDetailsPage(
                      individualEstate: widget.individualEstates[i]),
                ),
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CardWidget(
                  city: widget.individualEstates[i].city,
                  country: widget.individualEstates[i].country,
                  name: widget.individualEstates[i].name,
                  width: widget.cardSize,
                  height: widget.cardSize * 0.5625,
                  backgroundImage: widget.individualEstates[i].images.isNotEmpty
                      ? Image(
                          image:
                              AssetImage(widget.individualEstates[i].images[0]),
                        )
                      : null,
                ),
              ),
            ),
          ),
        );
        res.add(
          SizedBox(
            height: 36,
            width: MediaQuery.of(context).size.width,
          ),
        );
      }
    } else if (widget.companyEstates.isNotEmpty) {
      for (int i = 0; i < widget.companyEstates.length; ++i) {
        res.add(
          Hero(
            tag: widget.companyEstates[i].images[0],
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EstateDetailsPage(
                      companyEstate: widget.companyEstates[i]),
                ),
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CardWidget(
                  city: widget.companyEstates[i].city,
                  country: widget.companyEstates[i].country,
                  name: widget.companyEstates[i].name,
                  width: widget.cardSize,
                  height: widget.cardSize * 0.5625,
                  backgroundImage: widget.companyEstates[i].images.isNotEmpty
                      ? Image(
                          image: AssetImage(widget.companyEstates[i].images[0]),
                        )
                      : null,
                ),
              ),
            ),
          ),
        );
        res.add(
          SizedBox(
            height: 36,
            width: MediaQuery.of(context).size.width,
          ),
        );
      }
    }
    return res;
  }
}
