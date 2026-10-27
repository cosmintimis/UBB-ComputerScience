#pragma once
#include "event.h"
#include <string>
#include <vector>

class EventException
{
private:
	std::vector<std::string> errors;

public:
	EventException(std::vector<std::string>);
	std::vector<std::string> getErrors() const;
};

class EventValidator
{
public:
	EventValidator() {}
	static void validate(Event);
};