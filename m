From: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [Linux-ima-devel] Support for Crypto Agile format
	in IMA
Date: Wed, 8 Mar 2017 10:37:31 +0100
Message-ID: <f1b05280-fe8a-d43e-6e58-da2dc4018339@huawei.com>
References: <D1203BA5BAF1AF4DAC3967497AD1E070B74F64@lhreml502-mbs>
	<1488906121.3216.76.camel@linux.vnet.ibm.com>
	<3fe6b5b7-ed73-3488-c642-cf9dfc94e168@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <3fe6b5b7-ed73-3488-c642-cf9dfc94e168-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgold-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: "linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Silviu Vlasceanu <Silviu.Vlasceanu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On 3/7/2017 7:10 PM, Ken Goldman wrote:
> Since a lot of design work has gone into this, and there are
> implementations, my thought would be to see if it can be used rather
> than designing something new.

IMA format is different: the event type is not sent after the PCR.

>
>>> The TPM IDs should be also included in the ima-header entry. At the
>>> moment, these IDs are not exposed outside the TPM driver.
>>>
>>> Example of ASCII list:
>>> 0 0000000000000000000000000000000000000000 ima-header sha1:20|sha256:32
>>> 10 sha256:bba20e8b15e2f5948a181bc922fd1207b9d5ed549585ffa3ab6e44f8aaeb4b16 ima-ng sha1:0000000000000000000000000000000000000000 boot_aggregate
>>>
>>> The Crypto Agile format would be enabled by providing the new kernel
>>> parameter ima_template_hash=. The values can be:
>>> - <algo 1|...|algo N>
>>> - all (all algorithms supported by the TPM)
>
> Same comment here.  There is already a 9.2.2	TCG_PCR_EVENT2 Structure
> that can perhaps be reused.  Many people have reviewed and implemented it.

I was referring to the choices for users to enable the Crypto Agile
format.


> Among the advantages to reuse are:
>
> - The structures already exist, with precise definitions.
>
> - The lower layer structures like TPML_DIGEST_VALUES are already used
> for the extend operation, so the support functions already exist.

They are used internally, in the TPM driver.

My question is, should callers of TPM functions be aware of TCG
specific structures? I add in CC tpmdd-devel-5NWGOfrQmneRv+LV9MX5uti2KpX7p8Fi@public.gmane.org

If yes, TPM IDs need to be converted to crypto IDs by IMA,
to calculate the template digests. The same must be done
by parsers of the measurements list. This solution would not
be consistent, as IMA would provide TPM IDs for template digests
and strings, as crypto IDs, for file digests.

If not, TPM IDs could be converted to crypto IDs by the TPM driver.
IMA would supply digests for each PCR bank by using standard structures.


> - On the server side, it's desirable to have one event format for both
> the BIOS/UEFI event log and the IMA event log.
>
> - As someone who has written a parser for the SHA-1 format IMA log, the
> combination of binary and ascii, sometimes nul terminated, sometimes a
> length, sometimes fixed sizes, no defined maximums, and with layers of
> redundancy to be checked, made writing a secure parser difficult.

For template data in binary format, since the introduction of ima-ng,
IMA sends the total length and the length of each template field.
The same approach could be used for template digests.

Roberto

------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
