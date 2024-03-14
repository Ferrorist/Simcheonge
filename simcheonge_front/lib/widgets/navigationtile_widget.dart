class NavigationTile extends StatelessWidget {
  final String title;
  final List<String> data;
  final Widget screen;

  const NavigationTile({
    Key? key,
    required this.title,
    required this.data,
    required this.screen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
    );
  }
}
