import asyncio
from unittest import IsolatedAsyncioTestCase

# Azure imports - Eventhub - Generate test events
from azure.eventhub import EventData
from azure.eventhub.aio import EventHubProducerClient
from azure.identity.aio import DefaultAzureCredential

# Define eventhub settings - pull from config.py
import config
EVENT_HUB_FQDN = config.EVENT_HUB_FQDN
EVENT_HUB_NAME = config.EVENT_HUB_NAME

# Azure auth - default to azure cli
credential = DefaultAzureCredential()

# Generate events for eventhub and send
async def generate_events():

    # Client to send messages to event hub
    producer = EventHubProducerClient(
        fully_qualified_namespace=EVENT_HUB_FQDN,
        eventhub_name=EVENT_HUB_NAME,
        credential=credential,
    )
    print("Producer client created successfully...")

    # Create a batch to send to event hub
    async with producer:

        # Batch
        batch = await producer.create_batch()

        # Add events
        batch.add(EventData("100"))
        batch.add(EventData("200"))
        batch.add(EventData("300"))

        # Send events
        await producer.send_batch(batch)

        # Close auth credentials
        await credential.close()

        # If successful return true
        print("Wrote events to event hub successfully...")
        return True

# Test cases
class Test(IsolatedAsyncioTestCase):

    # Test 1 - generate_events - Generate and send events to event hub
    async def test_generate_events(self):
        result = await generate_events()
        self.assertTrue(result)

# Run main
asyncio.run(generate_events())