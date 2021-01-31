#pragma once

#include "Core.h"
//#include "Events/Event.h" // get error because when Application.cpp is compiled first include Event.h file and then hzpch.h file
#include "Window.h"
#include "Hazel/Events/ApplicationEvent.h"
#include "Hazel/LayerStack.h"

class Event;

namespace Hazel {

	class HAZEL_API Application
	{
	public:
	
		Application();
		virtual ~Application();

		void PushLayer(Layer* layer);
		void PushOverlay(Layer* overlay);

		void Run();
		void OnEvent(Event& e);


	private:
		LayerStack m_LayerStack;
		bool OnWindowClose(WindowCloseEvent& e);

		std::unique_ptr<Window> m_Window;
		bool m_Runing;
	};

	// TO be defined in CLIENT
	Application* CreateApplication();

}

