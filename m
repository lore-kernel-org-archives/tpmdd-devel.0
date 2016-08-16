From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2 2/3] TPM2.0: TPM Device Tree
 Documentation
Date: Tue, 16 Aug 2016 23:30:40 +0530
Message-ID: <57B354C8.5040906@linux.vnet.ibm.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1470771295-15680-3-git-send-email-nayna@linux.vnet.ibm.com>
	<20160809221239.GB5535@obsidianresearch.com>
	<57ADC2B5.3040903@linux.vnet.ibm.com>
	<20160813024230.GA26929@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160813024230.GA26929-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi Jason,

Thanks for the review. Please find my responses inline.

On 08/13/2016 08:12 AM, Jason Gunthorpe wrote:
> On Fri, Aug 12, 2016 at 06:06:05PM +0530, Nayna wrote:
>>>   Documentation/devicetree/bindings/submitting-patches.txt
>>>
>>> And be sure to follow all the requirements, including CC'ing the
>>> right maintainers
>
>> Sure, will do. Can you tell me who all should I copy ?
>
> That information is in the file

Sure..

>
>>>> Changelog v2:
>>>>          * Added documentation in v2.
>>>
>>> Do not include these lines in commit messages, put them after the
>>> diff stat.
Ok

>>
>> Actually I have not added Changelog during commit, I have put them in patch
>> before posting. However, will add them after diff next time.
>
> No diff, after the diffstat, before the deiff.

Ok.
>
>>>> +	phandle = <0x10000017>;
>>>> +	linux,phandle = <0x10000017>;
>>>
>>>   What are these?
>>
>> Sorry I didn't get your question here. I have written in the format as
>> suggested for device-tree documentation and looking at other device-nodes
>> documentation. And so this is an example entry as I saw in other docs.
>
> I mean the two phandle things

Here is the description:

phandle property:

The phandle property specifies a numerical identifier for a node that is 
unique within the device tree. The phandle property value is used by 
other nodes that need to refer to the node associated with the property.

linux,phandle property:

Older versions of device trees may be encountered that contain a 
deprecated form of this property called linux,phandle. For 
compatibility, a client program might want to support linux,phandle if a 
phandle property is not present. The meaning and use of the two 
properties is identical.

>
> Jason
>


------------------------------------------------------------------------------
