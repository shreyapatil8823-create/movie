import 'package:flutter/material.dart';

void main() {
  runApp(NextSceneApp());
}

class NextSceneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NextScene',
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;//Controls animation timing and execution.

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.1).animate(_controller);

    _controller.forward();//_controller.forward();Starts animation.

    // Navigate to Login after delay
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: const Text(
              "NextScene",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- LOGIN PAGE ----------------
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();//Controls and retrieves email input.

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (BuildContext context) => MainScreen()),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.network(
              "https://image.tmdb.org/t/p/original/9yBVqNruk6Ykrwc32qrK2TIE5xw.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(color: Colors.black.withOpacity(0.7)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "NextScene",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 40),

                  //  Email Field
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.black54,
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // Password Field
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.black54,
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 6) {
                        return "Minimum 6 characters required";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: login,
                    child: const Text("Login"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- MAIN SCREEN ----------------
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = <Widget>[
    HomePage(),
    DownloadsPage(),
    ProfilePage(),
    SettingsPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,//Displays movie details in a popup sheet.
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: "Downloads",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
        ],
      ),
    );
  }
}

// ---------------- HOME PAGE ----------------
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> watchlist = <String>[];
  void showMovieDetails(Map<String, dynamic> movie) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext _) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(movie["image"] as String, height: 200),
              ),
              const SizedBox(height: 10),
              Text(movie["title"] as String,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                "${movie["year"]} • ${movie["genre"]} • ⭐ ${movie["rating"]}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                movie["description"] as String,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        );
      },
    );
  }

  final List<Map<String, String>> movies = <Map<String, String>>[
    {
      "title": "Inception",
      "image": "https://image.tmdb.org/t/p/w500/edv5CZvWj09upOsy2Y6IwDhK8bt.jpg",
      "year": "2010",
      "genre": "Sci-Fi",
      "rating": "8.8",
      "description":
          "A thief who steals corporate secrets through dream-sharing technology is given a chance to erase his past."
    },
    {
      "title": "Interstellar",
      "image": "https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
      "year": "2014",
      "genre": "Sci-Fi",
      "rating": "8.6",
      "description":
          "A team travels through a wormhole in space in an attempt to ensure humanity's survival."
    },
    {
      "title": "The Dark Knight",
      "image": "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
      "year": "2008",
      "genre": "Action",
      "rating": "9.0",
      "description":
          "Batman faces the Joker, a criminal mastermind who plunges Gotham into chaos."
    },
    {
      "title": "Avengers: Endgame",
      "image": "https://image.tmdb.org/t/p/w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg",
      "year": "2019",
      "genre": "Action",
      "rating": "8.4",
      "description":
          "The Avengers assemble once more to reverse Thanos' actions and restore balance."
    },
    {
      "title": "Joker",
      "image": "https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg",
      "year": "2019",
      "genre": "Drama",
      "rating": "8.4",
      "description":
          "A failed comedian turns to a life of crime and chaos in Gotham City."
    },
    {
      "title": "Titanic",
      "image": "https://image.tmdb.org/t/p/w500/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg",
      "year": "1997",
      "genre": "Romance",
      "rating": "7.9",
      "description": "A love story unfolds aboard the ill-fated RMS Titanic."
    },
    {
      "title": "Avatar",
      "image": "https://image.tmdb.org/t/p/w500/6EiRUJpuoeQPghrs3YNktfnqOVh.jpg",
      "year": "2009",
      "genre": "Sci-Fi",
      "rating": "7.8",
      "description":
          "A marine on an alien planet becomes torn between following orders and protecting a new world."
    },
    {
      "title": "Spider-Man: No Way Home",
      "image": "https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
      "year": "2021",
      "genre": "Action",
      "rating": "8.2",
      "description":
          "Spider-Man seeks help to restore his secret identity, but things go wrong."
    },
    {
      "title": "Doctor Strange",
      "image": "https://image.tmdb.org/t/p/w500/uGBVj3bEbCoZbDjjl9wTxcygko1.jpg",
      "year": "2016",
      "genre": "Fantasy",
      "rating": "7.5",
      "description":
          "A surgeon learns the mystic arts after a career-ending accident."
    },
    {
      "title": "Black Panther",
      "image": "https://image.tmdb.org/t/p/w500/uxzzxijgPIY7slzFvMotPv8wjKA.jpg",
      "year": "2018",
      "genre": "Action",
      "rating": "7.3",
      "description":
          "T'Challa returns home to Wakanda to take his rightful place as king."
    },
    {
      "title": "Frozen",
      "image": "https://image.tmdb.org/t/p/w500/kgwjIb2JDHRhNk13lmSxiClFjVk.jpg",
      "year": "2013",
      "genre": "Animation",
      "rating": "7.4",
      "description":
          "A princess sets out to find her estranged sister whose powers have trapped their kingdom in eternal winter."
    },
    {
      "title": "The Lion King",
      "image": "https://image.tmdb.org/t/p/w500/2bXbqYdUdNVa8VIWXVfclP2ICtT.jpg",
      "year": "1994",
      "genre": "Animation",
      "rating": "8.5",
      "description":
          "A young lion prince flees his kingdom after his father's death."
    },
    {
      "title": "Harry Potter",
      "image": "https://image.tmdb.org/t/p/w500/uC6TTUhPpQCmgldGyYveKRAu8JN.jpg",
      "year": "2001",
      "genre": "Fantasy",
      "rating": "7.6",
      "description": "A young wizard discovers his magical heritage."
    },
    {
      "title": "The Matrix",
      "image": "https://image.tmdb.org/t/p/w500/aOIuZAjPaRIE6CMzbazvcHuHXDc.jpg",
      "year": "1999",
      "genre": "Sci-Fi",
      "rating": "8.7",
      "description": "A hacker discovers reality is a simulation controlled by machines."
    },
    {
      "title": "Gladiator",
      "image": "https://image.tmdb.org/t/p/w500/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg",
      "year": "2000",
      "genre": "Action",
      "rating": "8.5",
      "description":
          "A former Roman general seeks revenge against a corrupt emperor."
    },
    {
      "title": "Shutter Island",
      "image": "https://image.tmdb.org/t/p/w500/kve20tXwUZpu4GUX8l6X7Z4jmL6.jpg",
      "year": "2010",
      "genre": "Thriller",
      "rating": "8.2",
      "description":
          "A US Marshal investigates a psychiatric facility on a remote island."
    },
    {
      "title": "Fight Club",
      "image": "https://image.tmdb.org/t/p/w500/bptfVGEQuv6vDTIMVCHjJ9Dz8PX.jpg",
      "year": "1999",
      "genre": "Drama",
      "rating": "8.8",
      "description": "An insomniac office worker forms an underground fight club."
    },
    {
      "title": "Forrest Gump",
      "image": "https://image.tmdb.org/t/p/w500/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg",
      "year": "1994",
      "genre": "Drama",
      "rating": "8.8",
      "description":
          "A simple man unknowingly influences several historical events."
    },
    {
      "title": "The Shawshank Redemption",
      "image": "https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
      "year": "1994",
      "genre": "Drama",
      "rating": "9.3",
      "description":
          "Two imprisoned men bond over years, finding solace and redemption."
    },
    {
      "title": "Parasite",
      "image": "https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg",
      "year": "2019",
      "genre": "Thriller",
      "rating": "8.6",
      "description": "A poor family schemes to infiltrate a wealthy household."
    },
    {
      "title": "Dune",
      "image": "https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg",
      "year": "2021",
      "genre": "Sci-Fi",
      "rating": "8.0",
      "description":
          "A noble family becomes embroiled in a war for control of a desert planet."
    },
    {
      "title": "John Wick",
      "image": "https://image.tmdb.org/t/p/w500/fZPSd91yGE9fCcCe6OoQr6E3Bev.jpg",
      "year": "2014",
      "genre": "Action",
      "rating": "7.4",
      "description": "An ex-hitman seeks vengeance after losing everything."
    },
    {
      "title": "The Batman",
      "image": "https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg",
      "year": "2022",
      "genre": "Action",
      "rating": "7.9",
      "description":
          "Batman uncovers corruption while pursuing the Riddler."
    },
    {
      "title": "Deadpool",
      "image": "https://image.tmdb.org/t/p/w500/inVq3FRqcYIRl2la8iZikYYxFNR.jpg",
      "year": "2016",
      "genre": "Comedy",
      "rating": "8.0",
      "description":
          "A wisecracking mercenary gains superpowers and seeks revenge."
    },
    {
      "title": "Minions",
      "image": "https://image.tmdb.org/t/p/w500/dr02BDbX5n4CkSC6ZC9E3z0O5Lp.jpg",
      "year": "2015",
      "genre": "Animation",
      "rating": "6.4",
      "description": "Minions search for a new villain master."
    },
    {
      "title": "The Conjuring",
      "image": "https://image.tmdb.org/t/p/w500/wVYREutTvI2tmxr6ujrHT704wGF.jpg",
      "year": "2013",
      "genre": "Horror",
      "rating": "7.5",
      "description":
          "Paranormal investigators help a family terrorized by a dark presence."
    },
    {
      "title": "It",
      "image": "https://image.tmdb.org/t/p/w500/9E2y5Q7WlCVNEhP5GiVTjhEhx1o.jpg",
      "year": "2017",
      "genre": "Horror",
      "rating": "7.3",
      "description":
          "A group of kids face a terrifying clown named Pennywise."
    },
    {
      "title": "Fast & Furious",
      "image": "https://image.tmdb.org/t/p/w500/2hFvxCCWrTmCYwfy7yum0GKRi3Y.jpg",
      "year": "2009",
      "genre": "Action",
      "rating": "6.6",
      "description":
          "Street racers become involved in high-stakes heists."
    },
    {
      "title": "Thor",
      "image": "https://image.tmdb.org/t/p/w500/prSfAi1xGrhLQNxVSUFh61xQ4Qy.jpg",
      "year": "2011",
      "genre": "Fantasy",
      "rating": "7.0",
      "description": "The Norse god Thor is banished to Earth."
    }
  ];

  void toggleWatchlist(String title) {
    setState(() {
      if (watchlist.contains(title)) {
        watchlist.remove(title);
      } else {
        watchlist.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("NextScene"), backgroundColor: Colors.black),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _SectionTitle(title: "Trending Now"),
            _MovieList(
              movies: movies,
              watchlist: watchlist,
              onMovieTap: (Map<String, String> movie) {
                toggleWatchlist(movie["title"]!);
                showMovieDetails(movie);
              },
            ),
            _SectionTitle(title: "My Watchlist"),
            _WatchlistSection(
              watchlist: watchlist,
              onRemove: toggleWatchlist,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _MovieList extends StatelessWidget {
  const _MovieList({
    required this.movies,
    required this.watchlist,
    required this.onMovieTap,
  });

  final List<Map<String, String>> movies;
  final List<String> watchlist;
  final ValueChanged<Map<String, String>> onMovieTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, String> movie = movies[index];
          final bool isAdded = watchlist.contains(movie["title"]);

          return GestureDetector(
            onTap: () => onMovieTap(movie),
            child: Container(
              width: 140,
              margin: const EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            movie["image"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Icon(
                            isAdded
                                ? Icons.check_circle
                                : Icons.add_circle_outline,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(movie["title"]!,
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WatchlistSection extends StatelessWidget {
  const _WatchlistSection({
    required this.watchlist,
    required this.onRemove,
  });

  final List<String> watchlist;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (watchlist.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "No movies added yet",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      children: watchlist.map<Widget>((String movie) {
        return ListTile(
          title: Text(movie, style: const TextStyle(color: Colors.white)),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onRemove(movie),
          ),
        );
      }).toList(),
    );
  }
}

// ---------------- SETTINGS PAGE ----------------
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  String streamingQuality = "High";
  String downloadQuality = "Standard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      backgroundColor: Colors.black,
      body: ListView(
        children: <Widget>[
          const _SettingsSectionTitle(title: "Notifications"),
          SwitchListTile(
            title: const Text(
              "Allow Notifications",
              style: TextStyle(color: Colors.white),
            ),
            value: notificationsEnabled,
            activeColor: Colors.red,
            onChanged: (bool value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),
          const _SettingsSectionTitle(title: "Streaming Quality"),
          _QualityRadioTile(
            title: "Low",
            data: "~300 MB/hour",
            value: "Low",
            groupValue: streamingQuality,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  streamingQuality = value;
                });
              }
            },
          ),
          _QualityRadioTile(
            title: "Medium",
            data: "~700 MB/hour",
            value: "Medium",
            groupValue: streamingQuality,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  streamingQuality = value;
                });
              }
            },
          ),
          _QualityRadioTile(
            title: "High",
            data: "~1.5 GB/hour",
            value: "High",
            groupValue: streamingQuality,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  streamingQuality = value;
                });
              }
            },
          ),
          const _SettingsSectionTitle(title: "Download Quality"),
          _QualityRadioTile(
            title: "Low",
            data: "~250 MB/movie",
            value: "Low",
            groupValue: downloadQuality,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  downloadQuality = value;
                });
              }
            },
          ),
          _QualityRadioTile(
            title: "Standard",
            data: "~500 MB/movie",
            value: "Standard",
            groupValue: downloadQuality,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  downloadQuality = value;
                });
              }
            },
          ),
          _QualityRadioTile(
            title: "High",
            data: "~1 GB/movie",
            value: "High",
            groupValue: downloadQuality,
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  downloadQuality = value;
                });
              }
            },
          ),
          const _SettingsSectionTitle(title: "Devices"),
          const ListTile(
            title: Text(
              "Logged in Devices",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "2 devices currently active",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const _SettingsSectionTitle(title: "Permissions"),
          const ListTile(
            title: Text(
              "Storage Access",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "Used for downloads",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const ListTile(
            title: Text(
              "Network Access",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "Required for streaming",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const _SettingsSectionTitle(title: "Help & Feedback"),
          const ListTile(
            title: Text("Help Center", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
          const ListTile(
            title: Text("Send Feedback", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _QualityRadioTile extends StatelessWidget {
  const _QualityRadioTile({
    required this.title,
    required this.data,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String title;
  final String data;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(data, style: const TextStyle(color: Colors.grey)),
      value: value,
      groupValue: groupValue,
      activeColor: Colors.red,
      onChanged: onChanged,
    );
  }
}

// ---------------- OTHER PAGES ----------------
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  String profileName = "Movie Lover";

  String profileImage = "https://i.pravatar.cc/300";

  List<String> watchAgain = <String>["Inception", "Interstellar"];
  List<String> wishlist = <String>["Joker", "Avengers"];
  List<String> favorites = <String>["Inception"];

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.08).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeProfileImage(String url) {
    _controller.forward().then((void _) => _controller.reverse());

    setState(() {
      profileImage = url;
    });
  }

  void showImagePicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext _) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Choose Avatar",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _AvatarOption(
                      url: "https://i.pravatar.cc/300?img=1",
                      onTap: changeProfileImage),
                  _AvatarOption(
                      url: "https://i.pravatar.cc/300?img=5",
                      onTap: changeProfileImage),
                  _AvatarOption(
                      url: "https://i.pravatar.cc/300?img=10",
                      onTap: changeProfileImage),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.black),
      body: ListView(
        children: <Widget>[
          // 👤 PROFILE HEADER (Minimal)
          Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: showImagePicker,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profileName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Tap to change avatar",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 📊 QUICK STATS (Wishlist feel)
          Row(
            children: <Widget>[
              _InfoCard(title: "Wishlist", value: wishlist.length.toString()),
              _InfoCard(title: "Favorites", value: favorites.length.toString()),
              _InfoCard(title: "Watched", value: watchAgain.length.toString()),
            ],
          ),

          // 💳 SUBSCRIPTION (Simple, not OTT heavy)
          const _ProfileSectionTitle(title: "Plan"),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Premium • ₹499/month",
              style: TextStyle(color: Colors.grey),
            ),
          ),

          // 🎬 COLLECTIONS
          const _ProfileSectionTitle(title: "Watch Again"),
          _MovieGrid(movies: watchAgain),
          const _ProfileSectionTitle(title: "Wishlist"),
          _MovieGrid(movies: wishlist),
          const _ProfileSectionTitle(title: "Favorites"),
          _MovieGrid(movies: favorites),
        ],
      ),
    );
  }
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({required this.url, required this.onTap});

  final String url;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap(url);
      },
      child: CircleAvatar(backgroundImage: NetworkImage(url), radius: 28),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MovieGrid extends StatelessWidget {
  const _MovieGrid({required this.movies});

  final List<String> movies;

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text("No movies yet", style: TextStyle(color: Colors.grey)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: movies.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  movies[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Text(
              value,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(title,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class DownloadsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Downloads"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.download_for_offline_outlined,
                  size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text(
                "No Downloads",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "You can download movies only with a Premium subscription.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext _) => PaymentPage(),
                    ),
                  );
                },
                child: const Text("Buy Premium"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final List<Map<String, String>> paymentMethods = <Map<String, String>>[
    {"title": "UPI", "icon": "💸"},
    {"title": "Credit / Debit Card", "icon": "💳"},
    {"title": "Net Banking", "icon": "🏦"},
    {"title": "Wallet", "icon": "📱"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Choose Payment"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const Text(
              "Premium Plan",
              style: TextStyle(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "₹499 / month",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: paymentMethods.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, String> method = paymentMethods[index];
                  return Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: Text(
                        method["icon"]!,
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Text(
                        method["title"]!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext _) => AlertDialog(
                            backgroundColor: Colors.black,
                            title: const Text("Payment Successful",
                                style: TextStyle(color: Colors.white)),
                            content: const Text(
                              "You are now a Premium user 🎉",
                              style: TextStyle(color: Colors.grey),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: const Text("OK",
                                    style: TextStyle(color: Colors.red)),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // App Title
            const Text(
              "NextScene",
              style: TextStyle(
                color: Colors.red,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // Description
            const Text(
              "NextScene is a user-friendly movie streaming app that allows users to explore movies, add them to a watchlist, and enjoy watching movies online seamlessly.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            // Features Section
            const Text(
              "Features",
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            _FeatureItem(text: "Browse trending and popular movies"),
            _FeatureItem(text: "Add movies to your personal watchlist"),
            _FeatureItem(text: "Resume watching from where you left"),
            _FeatureItem(text: "Explore upcoming and most watched movies"),

            const SizedBox(height: 30),

            // Creators Section
            const Text(
              "Creators",
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            _CreatorItem(name: "Tharun K"),
            _CreatorItem(name: "Shreya Patil"),
            _CreatorItem(name: "Spandana"),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          const Icon(Icons.check_circle, color: Colors.red, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatorItem extends StatelessWidget {
  const _CreatorItem({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          const Icon(Icons.person, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
