import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:translator/translator.dart';
import '../../../domain/entities/history_event.dart';

class DetailPage extends StatefulWidget {
  final String year;
  final List<HistoryEvent> events;

  const DetailPage({super.key, required this.year, required this.events});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FlutterTts tts = FlutterTts();
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    tts.setLanguage('es-ES');
    tts.setSpeechRate(0.45);
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  void speakAllEvents() async {
    final events = widget.events.where((e) => e.year == widget.year);
    final joined = events.map((e) => e.text).join('. ');
    final translated = await translator.translate(joined, to: 'es');
    await tts.speak(translated.text);
  }

  @override
  Widget build(BuildContext context) {
    final yearEvents = widget.events.where((e) => e.year == widget.year).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 210,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Año ${widget.year}', style: const TextStyle(color: Colors.white)),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/history.jpg', fit: BoxFit.cover),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black45, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${yearEvents.length} evento(s) encontrado(s)',
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: Colors.teal),
                    onPressed: speakAllEvents,
                  )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final event = yearEvents[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.play_arrow_rounded, size: 24, color: Colors.teal),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  event.text,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: yearEvents.length,
            ),
          ),
        ],
      ),
    );
  }
}