import 'package:flutter/material.dart';
import 'package:job_search_app/colors.dart' as color;

class ViewMyJob extends StatefulWidget {
  const ViewMyJob({Key? key}) : super(key: key);

  @override
  _ViewMyJobState createState() => _ViewMyJobState();
}

class _ViewMyJobState extends State<ViewMyJob> {
  int a = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.white,
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: color.AppColor.welcomeImageContainer,
          fontSize: 20,
          fontFamily: 'BalsamiqSans_Regular',
          fontWeight: FontWeight.w500,
        ),
        leading: BackButton(
          color: color.AppColor.welcomeImageContainer,
        ),
        backgroundColor: Colors.white,
        title: Text('My Jobs'),
        elevation: 0,
      ),
      body: ListView.builder(
          padding: EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 10),
          itemCount: a,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                height: 165,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(58),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        color.AppColor.gradientFirst.withOpacity(0.5),
                        color.AppColor.gradientSecond.withOpacity(0.3),
                        color.AppColor.welcomeImageContainer.withOpacity(0.2),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.5, 0.5],
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(5, 10),
                        blurRadius: 20,
                        color: color.AppColor.gradientSecond.withOpacity(0.2),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color.AppColor.white,
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blueGrey,
                            backgroundImage:
                                AssetImage('assets/images/industry.jpg'),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Digital Marketing Intern',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color:
                                    color.AppColor.homePageContainerTextSmall,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Company Recruiter BH ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color:
                                    color.AppColor.homePageContainerTextSmall,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Applied Date',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color:
                                    color.AppColor.homePageContainerTextSmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: color.AppColor.homePageContainerTextSmall,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color.AppColor.homePageContainerTextSmall,
                          ),
                        ),
                        Text(
                          'Waiting-for-Evaluation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
