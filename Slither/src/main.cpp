#include <iostream>

#include <Nano/Nano.hpp>
#include <NanoNetworking/Server/Server.hpp>

// TODO: Make premake/NanoGraphics fix
#define NG_CONFIG_DEBUG
#define NG_API_VULKAN
#define NG_PLATFORM_DESKTOP
#define NG_PLATFORM_WINDOWS
#include <NanoGraphics/Core/Window.hpp>

int main(int argc, char* argv[])
{
	(void)argc; (void)argv;

	Nano::Graphics::Window* windowPtr;
	Nano::Graphics::Window window(
		Nano::Graphics::WindowSpecification()
			.SetTitle("Window")
			.SetWidthAndHeight(1280, 720)
			.SetFlags(Nano::Graphics::WindowFlags::Decorated | Nano::Graphics::WindowFlags::Focused | Nano::Graphics::WindowFlags::Resizable | Nano::Graphics::WindowFlags::Show)
			.SetEventCallback([&](Nano::Graphics::Event e) 
			{
				Nano::Events::EventHandler handler(e);
				handler.Handle<Nano::Graphics::WindowCloseEvent>([&](Nano::Graphics::WindowCloseEvent& e) { windowPtr->Close(); });
			})
	);
	windowPtr = &window;

	Nano::Networking::Server server;
	server.SetMessageCallback([](void* userData, Nano::Networking::MessageType type, const std::string& message) { std::cout << message << std::endl; });
	
	server.Start(8080).Wait();

	while (window.IsOpen())
	{
		window.PollEvents();

		//window.SwapBuffers();
	}

	server.Stop();
	return 0;
}