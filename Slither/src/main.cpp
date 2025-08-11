#include <iostream>

#include <Nano/Nano.hpp>
#include <NanoNetworking/Server/Server.hpp>

int main(int argc, char* argv[])
{
	(void)argc; (void)argv;

	Nano::Networking::Server server;
	server.SetMessageCallback([](void* userData, Nano::Networking::MessageType type, const std::string& message) { std::cout << message << std::endl; });
	
	server.Start(8080).Wait();
	std::cout << "HI" << std::endl;

	const auto start = Nano::Time::SinceEpoch<Nano::Time::Period::Seconds>();
	while (server.IsUp())
	{
		if (Nano::Time::SinceEpoch<Nano::Time::Period::Seconds>() >= start + 10)
			break;

		Nano::Time::Sleep<Nano::Time::Period::Milliseconds>(10);
	}

	server.Stop();
	return 0;
}