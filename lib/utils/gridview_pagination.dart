import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'my_constants.dart';

typedef Future<bool> OnNextPage(int nextPage);

class GridViewPagination extends StatefulWidget {
  final int itemCount;
  final double childAspectRatio;
  final OnNextPage onNextPage;
  final Function(BuildContext context, int position) itemBuilder;
  final Widget Function(BuildContext context) progressBuilder;
  bool isUserLogin = false;

  GridViewPagination({
    this.isUserLogin,
    this.itemCount,
    this.childAspectRatio,
    this.itemBuilder,
    this.onNextPage,
    this.progressBuilder,
  });

  @override
  _GridViewPaginationState createState() => _GridViewPaginationState();
}

class _GridViewPaginationState extends State<GridViewPagination> {
  int currentPage = 1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification sn) {
        if (!isLoading && sn is ScrollUpdateNotification && sn.metrics.pixels == sn.metrics.maxScrollExtent) {
          setState(() {
            this.isLoading = true;
          });
          widget.onNextPage?.call(currentPage++)?.then((bool isLoaded) {
            setState(() {
              this.isLoading = false;
            });
          });
        }
        return true;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              crossAxisCount: 3,
              childAspectRatio: widget.childAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              widget.itemBuilder,
              childCount: widget.itemCount,
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              addSemanticIndexes: true,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: widget.isUserLogin ? 40.0 : MyConstants.bottombar_height),
          ),
          if (isLoading)
            SliverToBoxAdapter(
              child: widget.progressBuilder?.call(context) ?? _defaultLoading(),
            ),
        ],
      ),
    );
  }

  Widget _defaultLoading() {
    return Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}