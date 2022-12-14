import 'package:app_movie/src/models/tvshow/tvshow_model.dart';
import 'package:app_movie/src/repository/tvshow_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../components/shimmer_trending.dart';
import '../pages/tvshows_details_page.dart';

class TVShowTrendingFutureBuilder extends StatelessWidget {
  const TVShowTrendingFutureBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customCacheManager = CacheManager(
      Config(
        'customCachedKey',
        stalePeriod: const Duration(days: 5),
      ),
    );

    return FutureBuilder<TvShowModel>(
      future: TVShowRepository().fetchTrending(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ShimmerTrending();
        } else {
          final data = snapshot.data;
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  mainAxisExtent: 150,
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: data!.results!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TVShowDetailsPage(
                            id: data.results![index].id,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        cacheManager: customCacheManager,
                        key: UniqueKey(),
                        imageUrl:
                            'https://image.tmdb.org/t/p/w400/${data.results![index].posterPath}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.black12),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black12,
                          child: const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 80,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }
}
