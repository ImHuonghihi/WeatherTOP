import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/utils/widgets/gesture_container.dart';

class ProgressCard extends StatelessWidget {
  ProgressCard(
      {Key? key, required this.ProjectName, required this.CompletedPercent})
      : super(key: key);
  late String ProjectName;
  late int CompletedPercent;
  @override
  Widget build(BuildContext context) {
    return GestureContainer.constrainedBox(
      onTap: () {},
      constraints: BoxConstraints(
        maxHeight: 70,
        minWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 3.0,
            margin: const EdgeInsets.only(top: 10),
            height: 49 * 0.01 * this.CompletedPercent,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: Container(
              height: 70,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: const Icon(Icons.assignment, color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      ProjectName,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "$CompletedPercent% Completed",
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
                Expanded(child: Container()),
                const Icon(
                  Icons.more_vert_outlined,
                  color: Colors.grey,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// progress card without expand widget for list scrolling
class ScrollProgressCard extends StatelessWidget {
  void Function()? onCardTap;

  void Function(String?)? onOptionTap;

  ScrollProgressCard(
      {Key? key,
      required this.ProjectName,
      required this.CompletedPercent,
      this.onOptionTap,
      this.onCardTap})
      : super(key: key);
  late String ProjectName;
  late int CompletedPercent;
  @override
  Widget build(BuildContext context) {
    return _buildCard(context, onCardTap);
  }

  Widget _buildCard(BuildContext context, void Function()? onCardTap) =>
      ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 70,
          minWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3.0,
              margin: const EdgeInsets.only(top: 10),
              height: 49 * 0.01 * this.CompletedPercent,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: Container(
                height: 70,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IntrinsicWidth(
                    child: Row(children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: const Icon(Icons.assignment, color: Colors.white),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: onCardTap,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        ProjectName,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "$CompletedPercent% Completed",
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  )),
                  Expanded(child: Container()),
                  DropdownButton(
                    icon: const Icon(
                      Icons.more_vert_outlined,
                      color: Colors.grey,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      DropdownMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onChanged: onOptionTap,
                  ),
                ])),
              ),
            ),
          ],
        ),
      );
}
