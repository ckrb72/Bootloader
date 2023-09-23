
void main()
{
	//Where the vga memory starts
	char* video_memory = (char*) 0xB8000;

	//Putting chars directly into memory
	*video_memory = 'Y';
	*(video_memory + 2) = 'O';
	*(video_memory + 4) = 'U';

}
