#!/usr/bin/env python3
import boto3
import json


def get_messages_from_queue(region, queue_url):
    sqs_client = boto3.client('sqs', region_name=region)

    while True:
        resp = sqs_client.receive_message(
            QueueUrl=queue_url,
            AttributeNames=['All'],
            MaxNumberOfMessages=10
        )

        try:
            yield from resp['Messages']
        except KeyError:
            return

        entries = [
            {'Id': msg['MessageId'], 'ReceiptHandle': msg['ReceiptHandle']}
            for msg in resp['Messages']
        ]

        resp = sqs_client.delete_message_batch(
            QueueUrl=queue_url, Entries=entries
        )

        if len(resp['Successful']) != len(entries):
            raise RuntimeError(
                f"Failed to delete messages: entries={entries!r} resp={resp!r}"
            )

if __name__ == '__main__':
    region = 'us-west-2'
    queue = 'us-identity-client-sftp-dead'
    queue_url = f'https://sqs.{region}.amazonaws.com/732655618226/{queue}'

    i = 0
    with open('output.json', 'w') as ostream:
        for message in get_messages_from_queue(region, queue_url):
            i += 1
            json.dump(message, ostream)
        ostream.write('\n')
    print(f'Wrote {i} messages to output.json')
