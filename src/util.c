int strcmpToEnd(char * str1, char * str2, int beg) {
	char c1;
	char c2;
	int i = 0;
	int result = -1;

	do {
		c1 = str1[i];
		c2 = str2[i + beg];

		if (c1 <= 10 && c2 <= 10) {
			result = 0;
		} else if (c1 != c2) {
			result = 1;
		}

		i++;
	} while (result < 0);

	return result;
}
