import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductScreen extends StatefulWidget {
  final String subCategory_id;
  final String category_id;

  const ProductScreen({Key? key, required this.subCategory_id, required this.category_id}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  YoutubePlayerController? _youtubeController;

  bool _isYoutubeLink(String? url) {
    if (url == null) return false;
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  String? _extractYoutubeVideoId(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }

  void _initializeYoutubeController(String videoId) {
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  Future<void> _launchIFleetWebsite() async {
    const url = 'https://www.ifleet.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2C51D),
        title: Text('Products'.tr),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Products')
              .where('section', isEqualTo: widget.subCategory_id)
              .where('category', isEqualTo: widget.category_id)

              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length ?? 0,
              itemBuilder: (context, i) {
                QueryDocumentSnapshot? x = snapshot.data?.docs[i];
                if (x == null) return Container();

                String? pictureUrl = x['picture'];
                bool isYoutube = _isYoutubeLink(pictureUrl);
                String? youtubeVideoId = _extractYoutubeVideoId(pictureUrl ?? '');

                if (isYoutube && youtubeVideoId != null) {
                  _initializeYoutubeController(youtubeVideoId);
                }

                return Card(
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (isYoutube && youtubeVideoId != null)
                          YoutubePlayer(
                            controller: _youtubeController!,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.red,
                          )
                        else
                          Image.network(
                            pictureUrl ?? '',
                            width: double.infinity,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                          ),
                        const SizedBox(height: 10),
                        Text(
                          '${x['name']}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${x['price']} EGP',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _launchIFleetWebsite,
                          child: const Text('Visit iFleet'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
