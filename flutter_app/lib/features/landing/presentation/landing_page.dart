import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../gallery/data/gallery_image.dart';
import '../../../gallery/data/gallery_repository.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        title: Text(
          'Our Story',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        actions: [
          _NavButton(label: 'Home', onTap: () => _scrollToSection(context, _SectionKey.hero)),
          _NavButton(
              label: 'Story', onTap: () => _scrollToSection(context, _SectionKey.story)),
          _NavButton(
              label: 'Timeline', onTap: () => _scrollToSection(context, _SectionKey.timeline)),
          _NavButton(
              label: 'Gallery', onTap: () => _scrollToSection(context, _SectionKey.gallery)),
          _NavButton(label: 'Notes', onTap: () => _scrollToSection(context, _SectionKey.notes)),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton(
              onPressed: () {
                if (currentUser == null) {
                  context.go('/login');
                } else {
                  context.go('/dashboard');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: currentUser == null
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                foregroundColor: currentUser == null
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
                side: currentUser == null
                    ? null
                    : BorderSide(color: Theme.of(context).colorScheme.primary),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(currentUser == null ? 'Log in' : 'Dashboard'),
            ),
          ),
        ],
      ),
      body: _LandingScrollView(
        sections: const [
          _HeroSection(),
          _StorySection(),
          _TimelineSection(),
          _GalleryPreviewSection(),
          _NotesSection(),
          _PlaylistSection(),
          _FooterSection(),
        ],
      ),
    );
  }
}

enum _SectionKey { hero, story, timeline, gallery, notes }

void _scrollToSection(BuildContext context, _SectionKey key) {
  final notifier = _SectionRegistry.of(context);
  notifier?.scrollTo(key);
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
      ),
    );
  }
}

class _LandingScrollView extends StatefulWidget {
  const _LandingScrollView({required this.sections});

  final List<Widget> sections;

  @override
  State<_LandingScrollView> createState() => _LandingScrollViewState();
}

class _LandingScrollViewState extends State<_LandingScrollView> {
  final ScrollController _controller = ScrollController();
  final Map<_SectionKey, GlobalKey> _sectionKeys = <_SectionKey, GlobalKey>{};

  @override
  void initState() {
    super.initState();
    for (final key in _SectionKey.values) {
      _sectionKeys[key] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollTo(_SectionKey key) {
    final targetKey = _sectionKeys[key];
    if (targetKey == null) return;

    final context = targetKey.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SectionRegistry(
      notifier: _SectionNotifier(scrollTo: _scrollTo),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFEFEA),
                  Color(0xFFFFF6F3),
                  Color(0xFFFFF8F6),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                for (int i = 0; i < widget.sections.length; i++)
                  _SectionWrapper(
                    key: i < _SectionKey.values.length ? _sectionKeys[_SectionKey.values[i]] : null,
                    child: widget.sections[i],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionWrapper extends StatelessWidget {
  const _SectionWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: child,
    );
  }
}

class _SectionNotifier {
  const _SectionNotifier({required this.scrollTo});

  final void Function(_SectionKey key) scrollTo;
}

class _SectionRegistry extends InheritedWidget {
  const _SectionRegistry({
    required super.child,
    required this.notifier,
  });

  final _SectionNotifier notifier;

  static _SectionNotifier? of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_SectionRegistry>();
    return inherited?.notifier;
  }

  @override
  bool updateShouldNotify(covariant _SectionRegistry oldWidget) => false;
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 960;
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: isWide ? 140 : 100,
            ),
            child: Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment:
                  isWide ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: isWide ? 5 : 0,
                  child: Column(
                    crossAxisAlignment:
                        isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Since 2023 · Still counting',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              letterSpacing: 2,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'This is the story of us',
                        textAlign: isWide ? TextAlign.left : TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Two souls who stumbled into each other’s orbit and never wanted to leave. Our days are stitched together with little rituals, road trips, late-night talks, and every photograph we take is a promise to remember.',
                        textAlign: isWide ? TextAlign.left : TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.75),
                            ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          ElevatedButton(
                            onPressed: () => _scrollToSection(context, _SectionKey.gallery),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            ),
                            child: const Text('See our moments'),
                          ),
                          OutlinedButton(
                            onPressed: () => _scrollToSection(context, _SectionKey.timeline),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            ),
                            child: const Text('Read our chapters'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Text(
                          '“We didn’t just fall in love—we started building a life we can’t stop dreaming about.”',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isWide) const SizedBox(width: 48) else const SizedBox(height: 32),
                Expanded(
                  flex: isWide ? 5 : 0,
                  child: _HeroCollage(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeroCollage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<GalleryImage>>(
      stream: GalleryRepository.instance.watchImages(limit: 2),
      builder: (context, snapshot) {
        final images = snapshot.data ?? <GalleryImage>[];
        return AspectRatio(
          aspectRatio: 4 / 5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 40,
                right: 0,
                child: _HeroImageCard(
                  imageUrl: images.length > 1 ? images[1].downloadUrl : null,
                  rotation: -4,
                  widthFactor: 0.68,
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                child: _HeroImageCard(
                  imageUrl: images.isNotEmpty ? images[0].downloadUrl : null,
                  rotation: 6,
                  widthFactor: 0.78,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.32,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favourite memory',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'It was the night of her debut, and neither of us got any sleep. We spent the whole night together, talking and laughing until dawn. As the morning came, we watched the sun rise side by side by the shore — a quiet, beautiful moment that felt like it belonged only to us.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroImageCard extends StatelessWidget {
  const _HeroImageCard({
    required this.imageUrl,
    required this.rotation,
    required this.widthFactor,
  });

  final String? imageUrl;
  final double rotation;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * widthFactor * 0.35;

    final Widget image = imageUrl != null && imageUrl!.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.cover,
              width: width,
              height: width * 1.1,
              placeholder: (context, url) => Container(
                width: width,
                height: width * 1.1,
                color: Colors.white,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) => Container(
                width: width,
                height: width * 1.1,
                color: Colors.white,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, size: 32),
              ),
            ),
          )
        : Container(
            width: width,
            height: width * 1.1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.favorite_outline,
              color: Theme.of(context).colorScheme.primary,
              size: 48,
            ),
          );

    return Transform.rotate(
      angle: rotation * 3.1415926535 / 180,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: image,
      ),
    );
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 900;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _StoryCard(
                    eyebrow: 'Chapter One',
                    title: 'How it all began',
                    paragraphs: const [
                      'We met unexpectedly. I got to know her because she’s the sister of my college friend. I never thought I’d end up liking her. At first, I tried to stop myself from falling, but I just couldn’t — I fell for her completely.',
                      'As days went by, we kept leaving little hints for each other through Instagram notes, until it reached the point where we’d chat and talk on calls all night long. I honestly never expected someone would come into my life and make me love this deeply.',
                    ],
                  ),
                ),
                if (isWide) const SizedBox(width: 24) else const SizedBox(height: 24),
                Expanded(
                  child: _StoryCard(
                    eyebrow: 'Chapter Two',
                    title: 'Pieces of our everyday',
                    paragraphs: const [
                      'Months passed, and we kept talking every day, slowly getting to know each other more deeply. There were times when I felt really down, but she was always there to comfort me — and I did the same whenever she was the one struggling. We’ve been through so many ups and downs, laughter and tears, but we always find our way back to each other.',
                      'We celebrate even our smallest victories in life, and what makes it even more special is that we get to share those moments together. The best part? We still feel like we’re just getting started.',
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({
    required this.eyebrow,
    required this.title,
    required this.paragraphs,
  });

  final String eyebrow;
  final String title;
  final List<String> paragraphs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.2,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 20),
          for (final paragraph in paragraphs) ...[
            Text(
              paragraph,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection();

  @override
  Widget build(BuildContext context) {
    final timelineEntries = [
      (
        date: 'June 2023',
        heading: 'Our first conversation',
        body:
            'I replied to your Instagram story — I took a risk, not knowing if you’d even notice me or not. But it was all worth it, because you did. You saw me, and that simple moment changed everything.'
      ),
      (
        date: 'December 2023',
        heading: 'The Letter That Made Us',
        body:
            'After months of courting you, you finally said yes — not through words, but through a heartfelt letter you handed me. Inside it were the sweetest words I’d been waiting for: that we were finally together.'
      ),
      (
        date: 'April 2024',
        heading: 'First Light by Your Side',
        body:
            'We stayed overnight at a private beach with your family, and it was the first time we slept side by side. We talked all night, and you were the first thing I saw when I woke up.'
      ),
      (
        date: 'December 2024 & beyond',
        heading: 'First Year',
        body:
            'It was our anniversary, and we started the day by going to church together. Afterward, we went to a photography studio to capture the moment — our first year together. We ended the day with a meal at a restaurant, celebrating our very first anniversary.'
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'Milestones',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.8,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'A timeline of us',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 680,
            child: Text(
              'Moments that changed us, frightened us, and made us fall in love over and over again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    height: 1.6,
                  ),
            ),
          ),
          const SizedBox(height: 48),
          Column(
            children: [
              for (final entry in timelineEntries)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          entry.date,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.heading,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              entry.body,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.6,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GalleryPreviewSection extends StatelessWidget {
  const _GalleryPreviewSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gallery',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            letterSpacing: 1.6,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Snapshots of our favourite days',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  'These are the photos that take us back—the blurry ones, the ones where we’re laughing too hard, the ones where we forgot the camera was there. Each picture is a chapter.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          StreamBuilder<List<GalleryImage>>(
            stream: GalleryRepository.instance.watchImages(limit: 20),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final images = snapshot.data ?? <GalleryImage>[];

              if (images.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No photos uploaded yet. Log in to add some memories!',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  _GalleryGrid(images: images),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: OutlinedButton(
                      onPressed: () => context.go('/gallery'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child: const Text('View all photos'),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GalleryGrid extends StatelessWidget {
  const _GalleryGrid({required this.images});

  final List<GalleryImage> images;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final crossAxisCount = constraints.maxWidth > 1100
          ? 4
          : constraints.maxWidth > 800
              ? 3
              : constraints.maxWidth > 520
                  ? 2
                  : 1;
      return GridView.builder(
        shrinkWrap: true,
        itemCount: images.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.95,
        ),
        itemBuilder: (context, index) {
          final image = images[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: image.downloadUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image),
              ),
            ),
          );
        },
      );
    });
  }
}

class _NotesSection extends StatelessWidget {
  const _NotesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'Letters to each other',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.8,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Words we never want to forget',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(builder: (context, constraints) {
            final double calculatedWidth =
                constraints.maxWidth > 840 ? 360 : constraints.maxWidth - 48;
            final double cardWidth = calculatedWidth.clamp(260.0, 420.0);

            return Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: const _NoteCard(
                    eyebrow: 'From me',
                    body:
                        '“You make everything softer and brighter. Thank you for listening when I ramble, for staying when things get tough, for reminding me that I am never alone. I love the way you call me out when I hide and the way you hold my hand when I hesitate.”',
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: const _NoteCard(
                    eyebrow: 'From you',
                    body:
                        '“You are the place my heart returns to. You make even the quiet days feel important. I love how you laugh at our inside jokes, how you notice every small thing, and how you always choose us.”',
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.eyebrow, required this.body});

  final String eyebrow;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eyebrow.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _PlaylistSection extends StatelessWidget {
  const _PlaylistSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Our soundtrack',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          letterSpacing: 1.4,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Songs that feel like us',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Press play to open “Until I Found You” by Stephen Sanchez—the song that feels like evening drives, warm hugs, and us humming along under our breath.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            FilledButton.icon(
              onPressed: () async {
                final uri = Uri.parse(
                  'https://www.youtube.com/watch?v=GxldQ9eX2wo&list=RDGxldQ9eX2wo&start_radio=1',
                );
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              icon: const Icon(Icons.music_note),
              label: const Text('Play our song'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            '“May we keep capturing moments that feel like home.”',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.75),
                ),
          ),
          const SizedBox(height: 12),
          Text(
            '© Raphael James Evangelio & Attacent Cheimen Malinao',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: 1,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

