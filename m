From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: TPM2 resource manager vendor specific commands
Date: Thu, 7 Jan 2016 16:07:53 -0500
Message-ID: <n6mk37$86r$1@ger.gmane.org>
References: <201512171523.tBHFNlJ6013434@d03av03.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA58648F1@EXCH2010A.sit.fraunhofer.de>
	<201512171620.tBHGK3GE030569@d03av04.boulder.ibm.com>
	<9F48E1A823B03B4790B7E6E69430724DA586493C@EXCH2010A.sit.fraunhofer.de>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754C@ABGEX74E.FSC.NET>
	<20151218105148.GA12882@intel.com> <20151218105323.GB12882@intel.com>
	<C5A28EF7B98F574C85C70238C8E9ECC04E6940754D@ABGEX74E.FSC.NET>
	<20151218114131.GA3287@intel.com> <n5144n$1ug$1@ger.gmane.org>
	<20151222065917.GB7867@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20151222065917.GB7867-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 12/22/2015 1:59 AM, Jarkko Sakkinen wrote:
>
> One of the corner cases are vendor specific commands. I raised that but
> it was ignored in this discussion.
>
> Now that I looked at TCG document it does not give any recommendation how
> they should be managed:

You are right that we should add this to the TCG documents.  We 
discussed this on a TPM WG call today.  Here's some design information 
for an implementer.

My high level conclusion is that the resource manager (RM) should not 
have any command specific handling.  It it does, that's a red flag that 
a vendor specific command may not work.

The TPM 2.0 design includes features to generalize vendor specific
commands.  There is a getcapability that returns command ordinal
properties, specifically:

- The number of command and response handles indicate whether and how 
many handles should be mapped.

- Whether transient objects are flushed.

- An extensive flag indicates that the command has many side effects. 
For these commands, the RM should use getcapability to enumerate the 
handles that are still active or loaded and synchronize its tables. 
TPM2_Clear is an example.






------------------------------------------------------------------------------
