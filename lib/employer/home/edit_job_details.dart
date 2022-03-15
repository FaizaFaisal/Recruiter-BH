import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_search_app/colors.dart' as color;
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:job_search_app/jobSearchResponse.dart';
import 'package:job_search_app/services/database_employer.dart';
import 'package:job_search_app/shared/custom_appbar.dart';
import 'package:job_search_app/shared/menu_widget.dart';

class edit_job_details extends StatefulWidget {
  final String job_id;

  const edit_job_details({Key? key, required this.job_id}) : super(key: key);

  @override
  _edit_job_details createState() => _edit_job_details();
}

// final todaydateFormatter =  DateFormat('dd-MM-yyyy hh:mm a').format(date);

class _edit_job_details extends State<edit_job_details> {
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();

  final firestoreInstance = FirebaseFirestore.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  jobSearchResponse? _jobsearchresponse;

  DateTime date = DateTime.now();
  var todaydate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  String? title = "";
  String? company = "";
  String? recruiter = "";
  String? targetDate = "";
  String? dateOpened = "";
  String? skills = "";
  String? role = "";
  String? responsibily = "";
  double salary = 0;
  String? city = "";
  String? country = "";
  String? description = "";
  String? jobtype = 'Full-Time';
  String? jobCategory = "Software";

  final jobTypeListItems = [
    'Full-Time',
    'Part time',
    'Contract',
  ];
  final jobCategoryItems = [
    'Software',
    'Accounts',
  ];
  String? experience = 'Fresher';
  final workExperienceItems = [
    'Fresher',
    '0-1 year',
    '1-3 years',
    '4-5 years',
    '5+years',
  ];

  String? industry = '-None-';
  final industryItems = [
    '-None-',
    'Government',
    'Communications',
    'Technology',
    'Education',
    'IT Services',
    'RealState',
    'Pharma',
    'Consulting',
    'Health Care',
    'Financial Services',
    'Construction',
  ];

  final titleController = TextEditingController();
  final comController = TextEditingController();
  final recruitController = TextEditingController();
  final targetController = TextEditingController();
  final dateOpenController = TextEditingController();
  final skillController = TextEditingController();
  final salController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final descriptionController = TextEditingController();
  final roleController = TextEditingController();
  final responseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    get_job();
    countryController.text = 'Bahrain (BH) [+973]';
    targetController.text = '$todaydate';
    dateOpenController.text = '$todaydate';
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      var fields = value.data();
      recruitController.text = fields!['name'] as String;
      comController.text = fields['companyName'] as String;
      print(fields['name'] as String);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    skillController.dispose();
    comController.dispose();
    recruitController.dispose();
    targetController.dispose();
    dateOpenController.dispose();
    salController.dispose();
    cityController.dispose();
    countryController.dispose();
    descriptionController.dispose();
    roleController.dispose();
    responseController.dispose();
    super.dispose();
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.AppColor.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: color.AppColor.welcomeImageContainer),
        actionsIconTheme:
            IconThemeData(color: color.AppColor.welcomeImageContainer),
        titleTextStyle: TextStyle(
          color: color.AppColor.welcomeImageContainer,
          fontSize: 20,
          fontFamily: 'BalsamiqSans_Regular',
          fontWeight: FontWeight.w500,
        ),
        title: Text(
          'Edit Details',
          textAlign: TextAlign.left,
        ),
        leading: BackButton(color: color.AppColor.welcomeImageContainer),
      ),
      body: SingleChildScrollView(reverse: true, child: jobpostUI(context)),
    );
  }

  //  Custom Widgets and on Tap Functions
  DropdownMenuItem<String> buildMenuItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(
            color: color.AppColor.homePageSubTitle,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  getExpiryDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2025),
    ).then((selectedDate) {
      if (selectedDate != null) {
        targetController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      }
    });
  }

  getOpenDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2025),
    ).then((selectedDate) {
      if (selectedDate != null) {
        dateOpenController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      }
    });
  }

  getName() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        recruiter = data!['name'];
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  jobpostUI(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Container(
            color: Colors.white,
            padding:
                const EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.01, width: width),
                TextFormField(
                  controller: titleController,
                  autofocus: false,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(Icons.title_outlined,
                        color: color.AppColor.welcomeImageContainer),
                    labelText: 'Title',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title.';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  readOnly: true,
                  autofocus: false,
                  controller: dateOpenController,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(
                      CupertinoIcons.calendar_today,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => {getOpenDatePicker()},
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 36,
                        color: color.AppColor.welcomeImageContainer,
                      ),
                    ),
                    labelText: 'Date Opened',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter date.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  readOnly: true,
                  autofocus: false,
                  controller: targetController,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(
                      CupertinoIcons.calendar_today,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => {getExpiryDatePicker()},
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 36,
                        color: color.AppColor.welcomeImageContainer,
                      ),
                    ),
                    labelText: 'Expiry Date',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter date.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.01),
                DropdownButtonFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    prefix: Text('Job-Type \t',
                        style: TextStyle(
                            color: color.AppColor.welcomeImageContainer,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                  isDense: true,
                  iconSize: 36,
                  icon: Icon(Icons.arrow_drop_down,
                      color: color.AppColor.welcomeImageContainer),
                  value: jobtype,
                  items: jobTypeListItems.map(buildMenuItem).toList(),
                  onChanged: (value) =>
                      setState(() => this.jobtype = value as String?),
                  validator: (value) {
                    if (value == null) {
                      return 'Select  Job.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.01),
                DropdownButtonFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    prefix: Text('Category \t',
                        style: TextStyle(
                            color: color.AppColor.welcomeImageContainer,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                  isDense: true,
                  iconSize: 36,
                  icon: Icon(Icons.arrow_drop_down,
                      color: color.AppColor.welcomeImageContainer),
                  value: jobCategory,
                  items: jobCategoryItems.map(buildMenuItem).toList(),
                  onChanged: (value) =>
                      setState(() => this.jobCategory = value as String?),
                  validator: (value) {
                    if (value == null) {
                      return 'Select  Job.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.01),
                DropdownButtonFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    prefix: Text('Experience \t',
                        style: TextStyle(
                            color: color.AppColor.welcomeImageContainer,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                  isDense: true,
                  iconSize: 36,
                  icon: Icon(Icons.arrow_drop_down,
                      color: color.AppColor.welcomeImageContainer),
                  value: experience,
                  items: workExperienceItems.map(buildMenuItem).toList(),
                  onChanged: (value) =>
                      setState(() => this.experience = value as String?),
                  validator: (value) {
                    if (value == null) {
                      return 'Select  Experience.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.01),
                DropdownButtonFormField(
                  autofocus: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.industry,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                  ),
                  isDense: true,
                  iconSize: 36,
                  icon: Icon(Icons.arrow_drop_down,
                      color: color.AppColor.welcomeImageContainer),
                  value: industry,
                  items: industryItems.map(buildMenuItem).toList(),
                  onChanged: (value) =>
                      setState(() => this.industry = value as String?),
                  validator: (value) {
                    if (value == null) {
                      return 'Select  Industry.';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  autofocus: false,
                  controller: skillController,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefix: Text('Skills \t',
                        style: TextStyle(
                            color: color.AppColor.welcomeImageContainer,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    labelText: 'Skills',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                  onChanged: (value) =>
                      setState(() => this.salary = value as double),
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  autofocus: false,
                  controller: salController,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefix: Text('Salary \t',
                        style: TextStyle(
                            color: color.AppColor.welcomeImageContainer,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                    labelText: 'Salary',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Location Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color.AppColor.welcomeImageContainer,
                      fontSize: 20,
                      fontFamily: 'BalsamiqSans_Bold'),
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  controller: cityController,
                  autofocus: false,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(
                      Icons.location_city,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    labelText: 'City',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter City';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: height * 0.02),
                TextFormField(
                  readOnly: true,
                  autofocus: false,
                  controller: countryController,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(
                      CupertinoIcons.placemark,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => {
                        showCountryPicker(
                          context: context,
                          countryListTheme: CountryListThemeData(
                            flagSize: 25,
                            backgroundColor: Colors.white,
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.blueGrey),
                            //Optional. Sets the border radius for the bottomsheet.
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                            //Optional. Styles the search field.
                            inputDecoration: InputDecoration(
                              labelText: 'Search',
                              hintText: 'Start typing to search',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xFF8C98A8).withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                          onSelect: (Country country) => {
                            print('Select country: ${country.displayName}'),
                            countryController.text = '${country.displayName}',
                          },
                        )
                      },
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 36,
                        color: color.AppColor.welcomeImageContainer,
                      ),
                    ),
                    labelText: 'Country',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select country.';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Despcription Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: color.AppColor.welcomeImageContainer,
                      fontSize: 20,
                      fontFamily: 'BalsamiqSans_Bold'),
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  controller: descriptionController,
                  autofocus: false,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    labelText: 'Description',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  controller: responseController,
                  autofocus: false,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(
                      CupertinoIcons.rectangle_on_rectangle_angled,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    labelText: 'Responsibilities',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                ),
                SizedBox(height: height * 0.01),
                TextFormField(
                  controller: roleController,
                  autofocus: false,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(color: Colors.redAccent, fontSize: 15),
                    prefixIcon: Icon(
                      Icons.person_search_outlined,
                      color: color.AppColor.welcomeImageContainer,
                    ),
                    labelText: 'Role',
                    labelStyle: TextStyle(
                        fontSize: 15, color: color.AppColor.homePagePlanColor),
                  ),
                ),
                SizedBox(height: height * 0.04),
                ElevatedButton(
                  onPressed: () {
                    ///update button
                    update_job();
                    /* if (_formKey.currentState!.validate()) {
                      setState(() {
                        title = titleController.text;
                        company = comController.text;
                        recruiter = recruitController.text;
                        city = cityController.text;
                        country = countryController.text;
                        dateOpened = dateOpenController.text;
                        targetDate = targetController.text;
                        skills = skillController.text;
                        salary = double.parse(salController.value.text);
                        description = descriptionController.text;
                        role = roleController.text;
                        responsibily = responseController.text;
                      });
                      postJob();
                    }*/
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.lato(
                        fontSize: 20, color: color.AppColor.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    fixedSize: Size(265, 40),
                    primary: color.AppColor.welcomeImageContainer,
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // postJob() async {
  //   await DatabaseEmployerService(uid: user!.uid).addJobOpening(
  //       title,
  //       company,
  //       recruiter,
  //       dateOpened,
  //       targetDate,
  //       jobtype!,
  //       experience!,
  //       industry!,
  //       skills,
  //       salary,
  //       city,
  //       country,
  //       description,
  //       responsibily,
  //       role,
  //       user!.email);
  //
  //   AwesomeDialog(
  //       context: context,
  //       animType: AnimType.SCALE,
  //       headerAnimationLoop: false,
  //       dialogType: DialogType.SUCCES,
  //       showCloseIcon: true,
  //       title: 'Succes',
  //       desc: 'Job Opened Successfully',
  //       btnOkOnPress: () {
  //         debugPrint('OnClcik');
  //       },
  //       btnOkIcon: Icons.check_circle,
  //       onDissmissCallback: (type) {
  //         debugPrint('Dialog Dissmiss from callback $type');
  //       })
  //     ..show();
  // }

  /// update job ////////////////////////////////////////////////////////
  Future<String?> update_job() async {
    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("job_opening")
          .doc(widget.job_id)
          .update({
        "job_id": widget.job_id,
        "company_id": FirebaseAuth.instance.currentUser!.uid,
        "job_title": titleController.text,
        "skill": skillController.text,
        // "industry":industry,
        "city": cityController.text,
        "country": countryController.text,
        "description": descriptionController.text,
        "responsibility": responseController.text,
        "role": roleController.text,
        "category": jobCategory,
        "experience": experience,
        "company_name": comController.text,
        "recruiter": recruitController.text,
        "date_start": dateOpenController.text,
        "date_end": targetController.text,
        "salary": salController.text,
        "job_type": jobtype,
        "job_status": "Active"
      }).then((value) {
        try {
          firestoreInstance.collection("jobs").get().then((value) {
            for (int i = 0; i < value.docs.length; i++) {
              String current_doc = value.docs[i].id.toString();
              try {
                firestoreInstance
                    .collection("jobs")
                    .doc(value.docs[i].id.toString())
                    .get()
                    .then((value) {
                  Map<String, dynamic>? h = value.data();
                  if (h != null) {
                    _jobsearchresponse = jobSearchResponse.fromJson(h);
                    print(_jobsearchresponse!.job_id);
                    if (_jobsearchresponse!.job_id == widget.job_id) {
                      firestoreInstance
                          .collection("jobs")
                          .doc(current_doc)
                          .update({
                        "job_id": widget.job_id,
                        "company_id": FirebaseAuth.instance.currentUser!.uid,
                        "job_title": titleController.text,
                        "skill": skillController.text,
                        // "industry":industry,
                        "city": cityController.text,
                        "country": countryController.text,
                        "description": descriptionController.text,
                        "responsibility": responseController.text,
                        "role": roleController.text,
                        "category": jobCategory,
                        "experience": experience,
                        "company_name": comController.text,
                        "recruiter": recruitController.text,
                        "date_start": dateOpenController.text,
                        "date_end": targetController.text,
                        "salary": salController.text,
                        "job_type": jobtype,
                        "job_status": "Active"
                      }).then((value) {
                        AwesomeDialog(
                            context: context,
                            animType: AnimType.SCALE,
                            headerAnimationLoop: true,
                            dialogType: DialogType.SUCCES,
                            showCloseIcon: true,
                            title: 'Succes',
                            desc: "job updated successfully",
                            btnOkOnPress: () {
                              debugPrint('OnClcik');
                            },
                            btnOkIcon: Icons.check_circle,
                            onDissmissCallback: (type) {
                              debugPrint('Dialog Dissmiss from callback $type');
                            })
                          ..show();
                      });
                    }
                  }
                }).whenComplete(() {
                  developer.log("my data g       ");
                  setState(() {});
                });
              } catch (e) {
                print(e.toString());
              }
            }
          });
        } catch (e) {
          print(e.toString());
        }
      });
    } catch (e) {
      _displaySnackBar(context, "No data Found");
    }
  }

  /// get jobs ////////////////////////////////////////////////////////
  Future<String?> get_job() async {
    try {
      firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("job_opening")
          .doc(widget.job_id)
          .get()
          .then((value) {
        Map<String, dynamic>? h = value.data();
        //developer.log("my Active job       "+ h.toString()+"    "+ h!['job_status'].toString());
        if (h != null) {
          _jobsearchresponse = jobSearchResponse.fromJson(h);
        }

        developer.log("my data g       " +
            h.toString() +
            "    " +
            _jobsearchresponse!.jobStatus);
      }).whenComplete(() {
        setState(() {
          titleController.text = _jobsearchresponse!.title;
          skillController.text = _jobsearchresponse!.skills;
          //industry = _jobsearchresponse!.industry;
          cityController.text = _jobsearchresponse!.city;
          countryController.text = _jobsearchresponse!.country;
          descriptionController.text = _jobsearchresponse!.description;
          responseController.text = _jobsearchresponse!.responsibility;
          roleController.text = _jobsearchresponse!.role;
          jobCategory = _jobsearchresponse!.category;
          experience = _jobsearchresponse!.experience;
          comController.text = _jobsearchresponse!.company;
          recruitController.text = _jobsearchresponse!.recruiter;
          dateOpenController.text = _jobsearchresponse!.dateOpen;
          targetController.text = _jobsearchresponse!.dateClose;
          salController.text = _jobsearchresponse!.salary;
          jobtype = _jobsearchresponse!.jobType;
        });
      });
    } catch (e) {
      _displaySnackBar(context, "No data Found");
    }
  }

  /// Show Snackbar ////////////////////////////////////////////////////////////////
  _displaySnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(
      backgroundColor: Colors.black,
      content: new Text(
        msg,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      duration: Duration(seconds: 7),
    );
    _scaffoldKey.currentState!.showSnackBar(snackBar);
  }
}
